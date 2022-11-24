//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/18/22.
//

import Foundation
import ArgumentParser
import MeetingKit

@main
struct Generate: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Generate meeting notes from calendar entries")
    
    @Option(name: .shortAndLong, help: "The meeting note to open")
    private var noteID: String?
    
    @Option(name:.shortAndLong, help: "Subdirectory to use")
    private var subDirectory = "work"
    
    @Flag
    private var verbose = false
    
    @Flag
    private var interactive = false
    
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
        guard verbose else { return }
        print(msg)
    }
    
    func actualRun() throws {
        guard let parentDir = ProcessInfo.processInfo.environment["NOTES_DIR"] else {
            print("$NOTES_DIR not set")
            return
        }
        verboseLog("notes dir: \(parentDir)")
        
        var baseDir = URL(fileURLWithPath: parentDir)
        if !subDirectory.isEmpty {
            baseDir.appendPathComponent(subDirectory)
        }
        verboseLog("baseDir: \(baseDir)")
        
        let events = getEvents()
        verboseLog("events found: \(events.count)")
        let template = try String(contentsOfFile: "\(parentDir)/shared/templates/meeting.md")
        
        let meetings = events.map { Meeting(from: $0) }
        
        try createNotes(meetings, in: baseDir, with: template)
        
        if let id = noteID {
            var toOpen = [Meeting]()
            if let timestamp = Double(id) {
                let meetingTime = Date(timeIntervalSince1970: timestamp)
                toOpen = meetings.filter { $0.startDate == meetingTime }
            } else {
                toOpen = meetings.filter { $0.id == id }
            }
            toOpen.forEach {
                openNote($0)
                // TODO: open attachments
            }
        }
        
        try cleanEmptyNotes()
    }
    
    func createNotes(_ notes: [Meeting], in notesURL: URL, with template: String) throws {
        try requestAccess()
        var written = [Meeting]()
        let toCreate = notes.filter {
            !FileManager.default.fileExists(atPath: $0.fullPath(dir: notesURL).path)
        }
        
        if toCreate.isEmpty {
            return
        }
        
        if interactive || verbose {
            summarize(notesURL, notes, toCreate)
        }
        
        if interactive {
            print("Continue? [y/N]")
            let input = readLine()
            if input?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "y" {
                return
            }
        }
        
        try toCreate.forEach { n in
            let p = n.fullPath(dir: notesURL)
            guard !FileManager.default.fileExists(atPath: p.path) else {
                print("\(p) exists, skipping")
                return
            }
            guard let d = n.note(with: template).data(using: .utf8) else {
                print("\(p) couldn't convert to data")
                return
            }
            try d.write(to: p)
            written.append(n)
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

func shell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    try task.run()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

func cleanEmptyNotes() throws {
    let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
    do {
        let files = try shell("find_empty_notes")
        try files.split(separator: "\n").forEach {
            let path = String($0)
            guard path.contains("/work/") else { return }
            let attrs = try FileManager.default.attributesOfItem(atPath: path)
            if let mod = attrs[.modificationDate] as? Date, mod < today {
                try FileManager.default.removeItem(atPath: path)
            }
        }
    } catch {
        print("error cleaning notes: \(error)")
    }
}
