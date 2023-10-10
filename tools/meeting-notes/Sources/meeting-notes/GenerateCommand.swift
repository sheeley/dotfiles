//
//  GenerateCommand.swift
//
//
//  Created by Johnny Sheeley on 11/18/22.
//

import ArgumentParser
import Darwin
import Foundation
import MeetingKit
import OSLog
import RegexBuilder

let logger = Logger()

// let startOfToday = Calendar.current.startOfDay(for: Date())
// let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())!)

enum DeleteWindow: String, CaseIterable {
    case past, future, all, none

    func includes(date: Date) -> Bool {
//        print("\(self) \(Date()) \(date)")
        switch self {
        case .none:
            return false
        case .past:
            return date < Date() // startOfToday
        case .future:
            return date > Date() // endOfToday
        case .all:
            return true
        }
    }
}

extension DeleteWindow: ExpressibleByArgument {}

struct GlobalOptions: ParsableArguments, CustomStringConvertible {
    var description: String {
        """
        ---
        baseDirectory:\t\(baseDirectory)
        vaultName:\t\(vaultName)
        subDirectory:\t\(subDirectory)
        clean:\t\(clean)
        openNoteID:\t\(openNoteID ?? "")
        ---
        """
    }

    @Option(name: .long, help: "Directory to create notes in")
    var baseDirectory: String = FileManager.default
        .homeDirectoryForCurrentUser
        .appending(components: "Library/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes")
        .path(percentEncoded: false)

    @Option(name: .long, help: "Vault to open notes in")
    var vaultName = "Apple Notes"

    @Option(name: .long, help: "'today', 'tomorrow', 'both', or a specific note ID")
    var create: String?

    @Option(name: .long, help: "Subdirectory to use")
    var subDirectory = ""

    @Option(name: .long, help: ArgumentHelp(DeleteWindow.allCases.map { $0.rawValue }.joined(separator: ", ")))
    var clean = DeleteWindow.none

    @Option(name: .long, help: "ID of note to open")
    var openNoteID: String?

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

    struct dirError: Error {}

    func actualRun() throws {
        try requestAccess()
//        verboseLog("\(options)")
        let parentDir = URL(filePath: options.baseDirectory, directoryHint: .isDirectory)
//        verboseLog("notes dir: \(parentDir)")

        var baseDir = parentDir
        if !options.subDirectory.isEmpty {
            baseDir.appendPathComponent(options.subDirectory)
        }
//        verboseLog("baseDir: \(baseDir)")

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
            }
            verboseLog("create: \(create)")

            let templateFile = parentDir.appending(components: "shared/templates/meeting.md")
            let access = templateFile.startAccessingSecurityScopedResource()
            verboseLog("template file (\(access)): \(templateFile)")

            let template = try String(contentsOf: templateFile)
            templateFile.stopAccessingSecurityScopedResource()

            let events = getEvents(in: window)
            verboseLog("events found: \(events.count)")
            if events.isEmpty {
                if case let .specificEvent(id) = window {
                    print("Couldn't find event \(id)")
                    Darwin.exit(1)
                }
                Darwin.exit(0)
            }

            let meetings = events.map { Meeting(from: $0) }
            verboseLog("\(meetings.humanReadable())")
            try createNotes(meetings, in: baseDir, with: template, and: options)

            if open, let meeting = meetings.first {
                openNote(meeting, vault: options.vaultName)
            }

            if let openNoteID = options.openNoteID {
                verboseLog("attempting to open \(openNoteID)")
                if let event = getEvents(in: EventWindow.specificEvent(id: openNoteID)).first {
                    openNote(Meeting(from: event), vault: options.vaultName)
                }
            }
        }
    }

    func createNotes(_ notes: [Meeting], in notesURL: URL, with template: String, and options: GlobalOptions) throws {
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
                verboseLog("creating \(p.absoluteString)")
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

func openNote(_ note: Meeting, vault vaultName: String) {
    let notePath = note.filename()
//    let url = "obsidian://open?vault=Notes&file=\(notePath)"
    // Advanced URI plugin lets us open in a new split.
    let url = "obsidian://advanced-uri?vault=\(vaultName)&filepath=\(notePath)&openmode=split"
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

    Optionally {
        " "
        Capture {
            Repeat(.digit, count: 2)
        } transform: { Int($0) }
        "-"
        Capture {
            Repeat(.digit, count: 2)
        } transform: { Int($0) }
    }
}

func cleanEmptyNotes(using options: GlobalOptions) throws {
    do {
        let files = try shell("find_empty_notes ", with: ProcessInfo.processInfo.environment).split(separator: "\n")
        print("found \(files.count) empty note files")
        try files.forEach {
            let path = String($0)
            guard path.contains(options.subDirectory) else { return }

            guard let match = path.firstMatch(of: dateRegex) else { return }
            let (_, year, month, day, hour, minutes) = match.output

            if let fileDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour ?? 0, minute: minutes ?? 0)),
               options.clean.includes(date: fileDate)
            {
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
