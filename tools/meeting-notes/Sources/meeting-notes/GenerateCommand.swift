//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/18/22.
//

import Foundation
import ArgumentParser
import MeetingKit
import OSLog
import RegexBuilder

let logger = Logger()

enum DeleteWindow: String, CaseIterable {
    case past, future, all, none
    
    func includes(date: Date) -> Bool {
        switch self {
        case .none:
            return false
        case .past:
            return date < Date()
        case .future:
            return date > Date()
        case .all:
            return true
        }
    }
}

extension DeleteWindow: ExpressibleByArgument {}

struct GlobalOptions: ParsableArguments {
    @Option(name: .long, help: "'today', 'tomorrow', 'both', or a specific note id")
    var create: String?
    
    @Option(name:.long, help: "Subdirectory to use")
    var subDirectory = "work"
    
    @Option(name: .long, help: ArgumentHelp(DeleteWindow.allCases.map { $0.rawValue }.joined(separator: ", ")))
    var clean = DeleteWindow.none
    
    @Flag
    var verbose = false
    
    @Flag
    var interactive = false
    
    @Flag
    var dryRun = false
    
    @Flag
    var force = false
}

@main
struct Generate: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Generate meeting notes from calendar entries")
    
    @OptionGroup
    var options: GlobalOptions
    
    func run() throws {
        do {
            try actualRun()
        } catch {
            print(error)
            print(Thread.callStackSymbols)
            _ = try shell("osascript -e 'display notification \"\(error)\"'")
            throw error
        }
    }
    
    func verboseLog(_ msg: String) {
        guard options.verbose else { return }
        print(msg)
    }
    
    func actualRun() throws {
        guard let parentDir = ProcessInfo.processInfo.environment["NOTES_DIR"] else {
            logger.error("$NOTES_DIR not set")
            print("$NOTES_DIR not set")
            return
        }
        logger.info("notes dir: \(parentDir)")
        verboseLog("notes dir: \(parentDir)")
        
        var baseDir = URL(fileURLWithPath: parentDir)
        if !options.subDirectory.isEmpty {
            baseDir.appendPathComponent(options.subDirectory)
        }
        verboseLog("baseDir: \(baseDir)")
        
        verboseLog("\(options)")
        if options.clean != .none {
            logger.info("cleaning \(options.clean.rawValue)")
            verboseLog("cleaning \(options.clean.rawValue)")
            try cleanEmptyNotes(using: options)
        }
        
        if let create = options.create {
            var open = false
            var window = EventWindow.today
            switch create {
            case "today":
                window = .today
            case "tomorrow":
                window = .tomorrow
            case "either":
                window = .either
            default:
                window = EventWindow.specificEvent(id: create)
                open = true
                break
            }
            
            let events = getEvents(in: window)
            verboseLog("events found: \(events.count)")
            let template = try String(contentsOfFile: "\(parentDir)/shared/templates/meeting.md")
            let meetings = events.map { Meeting(from: $0) }
            verboseLog("\(meetings)")
            try createNotes(meetings, in: baseDir, with: template, and: options)
            if open {
                openNote(meetings.first!)
            }
        }
    }
    
    func createNotes(_ notes: [Meeting], in notesURL: URL, with template: String, and options: GlobalOptions) throws {
        try requestAccess()
        var written = [Meeting]()
        let toCreate = options.force ? notes : notes.filter {
            !FileManager.default.fileExists(atPath: $0.fullPath(dir: notesURL).path)
        }
        
        if toCreate.isEmpty {
            return
        }
        
        if options.interactive || options.verbose {
            summarize(notesURL, notes, toCreate)
        }
        
        if options.interactive {
            print("Continue? [y/N]")
            let input = readLine()
            if input?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "y" {
                return
            }
        }
        
        try toCreate.forEach { n in
            let p = n.fullPath(dir: notesURL)
            guard !FileManager.default.fileExists(atPath: p.path) || options.force else {
                print("\(p) exists, skipping")
                return
            }
            
            guard let d = n.note(with: template).data(using: .utf8) else {
                print("\(p) couldn't convert to data")
                return
            }
            
            if !options.dryRun {
                try d.write(to: p)
                written.append(n)
            }
        }
    }
}

func summarize(_ u: URL, _ allNotes: [Meeting], _ toCreate: [Meeting]) {
    print("Found \(allNotes.count) events, will create \(toCreate.count):")
    toCreate.forEach {
        print($0.fullPath(dir: u))
    }
}

func openNote(_ note: Meeting) {
    let notePath = note.filename()
    let url = "obsidian://open?vault=Notes&file=\(notePath)"
    let task = Process()
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = [url]
    task.launchPath = "/usr/bin/open"
    task.launch()
}

func shell(_ command: String, with environment: [String: String]? = nil) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.environment = environment
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    try task.run()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

let dateRegex = Regex {
    Capture {
        Repeat(.digit, count: 4)
    } transform: { Int($0) }
    "-"
    Capture {
        Repeat(.digit, count: 2)
    } transform: { Int($0) }
    "-"
    Capture {
        Repeat(.digit, count: 2)
    } transform: { Int($0) }
}

func cleanEmptyNotes(using options: GlobalOptions) throws {
    do {
        let files = try shell("find_empty_notes ", with: ProcessInfo.processInfo.environment).split(separator: "\n")
        print("found \(files.count) empty note files")
        try files.forEach {
            let path = String($0)
            guard path.contains(options.subDirectory) else { return }
            
            let matches = path.matches(of: dateRegex)
            if matches.count != 1 { return }
            let match = matches.first!
            let year = match.output.1
            let month = match.output.2
            let day = match.output.3
            
            if let fileDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)),
               options.clean.includes(date: fileDate) {
                print("Deleting \(path)")
                if !options.dryRun {
                    try FileManager.default.removeItem(atPath: path)
                }
            }
        }
    } catch {
        print("error cleaning notes: \(error)")
    }
}
