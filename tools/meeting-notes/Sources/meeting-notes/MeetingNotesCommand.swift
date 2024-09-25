//
//  MeetingNotesCommand.swift
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
import System
import UserNotifications

let logger = Logger()

// let startOfToday = Calendar.current.startOfDay(for: Date())
// let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())!)

@main
struct MeetingNotesCommand: ParsableCommand {
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
        notify(msg)
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
      
      let create = options.create ?? ((options.interactive) ? "interactive" : nil)

      guard let create else {
        print("no create option!");
        return
      }
            var open = false
            var window = EventWindow.today
            switch create {
            case "today":
                window = .today
            case "tomorrow":
                window = .tomorrow
            case "either":
                window = .either
            case "interactive":
                let eventId = interactivelySelectEvent()
                window = EventWindow.specificEvent(id: eventId)
                open = true
            default:
                window = EventWindow.specificEvent(id: create)
                open = true
            }
            verboseLog("create: \(create)")

            let templateFile = parentDir.appending(components: "shared/templates/meeting.md")
            let access = templateFile.startAccessingSecurityScopedResource()
            verboseLog("template file (\(access)): \(templateFile)")

            let template = try String(contentsOf: templateFile)
            if template.isEmpty {
                print("WTF template is empty!!!!!")
              notify("TEMPLATE IS EMPTY")
                Darwin.exit(1)
            }
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

            verboseLog("created, opening notes")
            if open, let meeting = meetings.first {
                openNote(meeting, vault: options.vaultName, options: options.obsidianOptionsMap())
            }

            if let openNoteID = options.openNoteID {
                verboseLog("attempting to open \(openNoteID)")
                if let event = getEvents(in: EventWindow.specificEvent(id: openNoteID)).first {
                    openNote(Meeting(from: event), vault: options.vaultName, options: options.obsidianOptionsMap())
                }
            }
    }

    func createNotes(_ notes: [Meeting], in notesURL: URL, with template: String, and options: GlobalOptions) throws {
        var written = [Meeting]()
        let fm = FileManager.default
      
        let toCreate = options.force ? notes : notes.filter {
          !fm.fileExists(atPath: $0.fullPath(dir: notesURL).path)
        }

        if toCreate.isEmpty {
          notify("No notes to create")
          return
        }

        if options.interactive || options.verbose {
            summarize(notesURL, notes, toCreate, template)
        }

        if options.interactive {
            print("Continue? [y/N]")
            let input = readLine()
            if input?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "y" {
                return
            }
        }
        
        try toCreate.forEach { n in
            let noteURL = n.fullPath(dir: notesURL)

            let parentDirectory = noteURL.deletingLastPathComponent()
            if !fm.fileExists(atPath: parentDirectory.path()) {
                try fm.createDirectory(at: parentDirectory, withIntermediateDirectories: true)
            }

            guard !fm.fileExists(atPath: noteURL.path) || options.force else {
                print("\(noteURL) exists, skipping")
                return
            }

            guard let d = n.note(with: template).data(using: .utf8) else {
                print("\(noteURL) couldn't convert to data")
                return
            }

            if !options.dryRun {
                verboseLog("creating \(noteURL.absoluteString)")
                try d.write(to: noteURL)
                written.append(n)
            }
        }
    }
}

func interactivelySelectEvent() -> String {
    let events = getEvents(in: .today)
    if events.isEmpty {
        print("No events today")
        exit(1)
    }

    var id = 0
    for event in events {
        print("\(id): \(event.title!) (\(event.calendar.title))")
        id += 1
    }

    while true {
        if let line = readLine(strippingNewline: true), let selectedId = Int(line), selectedId < events.count {
            return events[selectedId].calendarItemIdentifier
        }
    }
}

func notify(_ s: String) {
  print(s)
  // TODO: Do I actually want notifications?
//  NotificationCenterWrapper.requestAuth()
//  NotificationCenterWrapper.sendNotification(title: "Meeting Notes", body: s)
}

func summarize(_ u: URL, _ allNotes: [Meeting], _ toCreate: [Meeting], _ template: String) {
    print("SUMMARY\nFound \(allNotes.count) events, will create \(toCreate.count):")
    for item in toCreate {
        print(item.fullPath(dir: u))
    }
    print("using template:\n------\(template)------\n")
}

func openNote(_ note: Meeting, vault vaultName: String, options: [String: String] = [:]) {
//    let url = "obsidian://open?vault=Notes&file=\(notePath)"
    // Advanced URI plugin lets us open in a new split.
    guard var URL = URL(string: "obsidian://advanced-uri") else {
        print("NO URL!?!?!?!?")
        return
    }
    URL.append(queryItems: [
        URLQueryItem(name: "vault", value: vaultName),
        URLQueryItem(name: "filepath", value: note.filename()),
    ])
    for (key, value) in options {
        URL.append(queryItems: [URLQueryItem(name: key, value: value)])
    }
    let url = URL.absoluteString
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
            if options.verbose {
                print("Deleting \(path)")
            }
            guard path.contains(options.subDirectory) else { return }

            guard let match = path.firstMatch(of: dateRegex) else { return }
            let (_, year, month, day, hour, minutes) = match.output

            if let fileDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour ?? 0, minute: minutes ?? 0)),
               options.clean.includes(date: fileDate)
            {
                let cleanedPath = FilePath(path)
                if !FileManager.default.fileExists(atPath: cleanedPath.string) {
                    print("missing \(cleanedPath.string)")
                } else {
                    print("Deleting \(cleanedPath.string)")
                    if !options.dryRun {
                        try FileManager.default.removeItem(atPath: cleanedPath.string)
                    }
                }
            }
        }
    } catch {
        print("error cleaning notes: \(error)")
    }
}
