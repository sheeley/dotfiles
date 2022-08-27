#!/usr/bin/env xcrun swift
import EventKit
import Foundation
import System

enum action: String { case today, tomorrow }
let subdir = "work"
var interactive = false
let store = EKEventStore()
var df: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH-mm"
    return df
}()

var fileNameCharacters = NSCharacterSet.punctuationCharacters
fileNameCharacters.remove(charactersIn: "-_.")

// MARK: - Filters and Modifiers

func titleModifier(_ title: String?) -> String {
    guard var title = title else { return "" }
    if let range = title.range(of: #"(( ?/ ?Johnny)|(Johnny ?/? ?))"#, options: .regularExpression) {
        title = title.replacingCharacters(in: range, with: "")
        if !title.contains("1o1"), !title.contains("1:1") {
            title += " 1o1"
        }
    }
    return title
}

func attendeeFilter(_ name: String) -> Bool {
    guard !name.starts(with: "Virtual"), name != "Johnny Sheeley" else { return false }
    return true
}

func eventFilter(_ event: EKEvent) -> Bool {
    guard event.hasAttendees else { return false }
    if let me = event.attendees?.filter({ $0.isCurrentUser }).first, me.participantStatus == .declined {
        return false
    }
    // guard let title = event.title, !title.contains("Status") else { return false }
    return true
}

func noteFilter(_ notes: String?) -> String {
    guard var notes = notes else { return "" }
    notes = filterOutWebex(notes)
    guard !notes.isEmpty else { return "" }
    return "---\n\(notes)\n---"
}

func filterOutWebex(_ n: String) -> String {
    var out = ""
    var ignoreLine = false
    n.enumerateLines { l, _ in
        if ignoreLine {
            if l == "---===---" {
                ignoreLine = false
            }
            return
        } else if l == "----( Virtual Conference One-Time Room )----" {
            ignoreLine = true
            return
        }
        out += "\(l)\n"
    }
    return out
}

// MARK: - Calendar

func requestAccess() throws {
    let sema = DispatchSemaphore(value: 0)
    store.requestAccess(to: .event) { allowed, err in
        guard allowed, err == nil else { exit(1) }
        sema.signal()
    }
    _ = sema.wait(timeout: .distantFuture)
}

func getEvents(_ filter: action) -> [EKEvent] {
    let today = Calendar.current.startOfDay(for: Date())
    let tomorrow = Date().addingTimeInterval(60 * 60 * 24)
    let predicate = store.predicateForEvents(withStart: today, end: tomorrow, calendars: nil)
    let events = store.events(matching: predicate)
    return events.filter { event in
        guard event.attendees?.count ?? 0 > 1 else { return false }
        guard !event.isAllDay else { return false }
        guard eventFilter(event) else { return false }
        return Calendar.current.isDateInToday(event.startDate) || Calendar.current.isDateInTomorrow(event.startDate)
    }
}

var ignoredDomains = [
    ".*webex.com.*((join){1}|(meet){1}|(MTID){1}|(onstage){1})",
    ".*bluejeans.com.*\\d+",
    ".*teams.*.com.*meet",
    ".*meet.google.com/(.*-.*)+",
    ".*zoom.us.*/\\d{6,99}",
    ".*gotomeeting.com/join/\\d+|.*meet.goto.com/\\d+",
    ".*facetime.apple.com/join.*",
    "s.apple.com"
]

extension URL {
    var isVideoChatHost: Bool {
        for domain in ignoredDomains {
            if absoluteString.range(of: domain, options: .regularExpression) != nil { return true }
        }
        return false
    }
}


// MARK: - Note Files

struct Note {
    let event: EKEvent
    let contents: String

    init(_ template: String, event: EKEvent) {
        let dateTime = df.string(from: event.startDate)

        var attendeeText = ""
        if let attendees = event.attendees {
            var seen = Set<EKParticipant>()
            attendeeText += attendees.compactMap { a in
                guard let name = a.name else { return nil }
                guard attendeeFilter(name) else { return nil }
                guard !seen.contains(a) else { return nil }
                seen.insert(a)
                return "  - \"[[\(name.replacingOccurrences(of: " (V)", with: ""))]]\"\n"
            }
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        }
        if !attendeeText.isEmpty {
            attendeeText = "\nattendees:\n  \(attendeeText)"
        }

        if let url = event.url, !url.isVideoChatHost {
            attendeeText += "\nurl: \(url.absoluteString)\n"
        }

        self.event = event
        contents = template
            .replacingOccurrences(of: "attendees: ", with: "attendees:")
            .replacingOccurrences(of: "attendees:\n  - \"[[]]\"", with: attendeeText)
            .replacingOccurrences(of: "{{date:YYYY-MM-DD HH:mm:ss}}", with: dateTime)
            .replacingOccurrences(of: "{{notes}}", with: noteFilter(event.notes))
            .replacingOccurrences(of: "{{title}}", with: titleModifier(event.title))
            .replacingOccurrences(of: "{{id}}", with: event.eventIdentifier)
    }

    func filename() -> String {
        let dateTime = df.string(from: event.startDate)
        var filename = titleModifier(event.title)
        filename.unicodeScalars.removeAll(where: { fileNameCharacters.contains($0) })
        return "\(dateTime) - \(filename).md"
    }

    func fullPath(dir: URL) -> URL {
        return dir.appendingPathComponent(subdir).appendingPathComponent(filename())
    }
}

func summarize(_ u: URL, _ allNotes: [Note], _ toCreate: [Note]) {
    print("Found \(allNotes.count) events, will create \(toCreate.count):")
    toCreate.forEach {
        print($0.fullPath(dir: u))
    }
}

func createNotes(_ notes: [Note], in notesURL: URL) throws {
    try requestAccess()
    var written = [Note]()
    let toCreate = notes.filter {
        !FileManager.default.fileExists(atPath: $0.fullPath(dir: notesURL).path)
    }

    if toCreate.isEmpty {
        return
    }

    if interactive {
        summarize(notesURL, notes, toCreate)
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
        guard let d = n.contents.data(using: .utf8) else {
            print("\(p) couldn't convert to data")
            return
        }
        try d.write(to: p)
        written.append(n)
    }
}

func openNote(_ note: Note) {
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
            let attrs = try FileManager.default.attributesOfItem(atPath: path)
            if let mod = attrs[.modificationDate] as? Date, mod < today {
                try FileManager.default.removeItem(atPath: path)
            }
        }
    } catch {
        print("error cleaning notes: \(error)")
    }
}

// MARK: - Main

func main() throws {
    let args = CommandLine.arguments
    var command = action.today
    if args.count > 1 {
        command = action(rawValue: args[1]) ?? command
    }

    guard let parentDir = ProcessInfo.processInfo.environment["NOTES_DIR"] else {
        print("$NOTES_DIR not set")
        return
    }

    let events = getEvents(command)
    let template = try String(contentsOfFile: "\(parentDir)/shared/templates/meeting.md")
    let notes = events.map { Note(template, event: $0) }

    try createNotes(notes, in: URL(fileURLWithPath: parentDir))

    if args.count > 2 {
        let id = args[2]
        var toOpen = [Note]()
        if let timestamp = Double(id) {
            let meetingTime = Date(timeIntervalSince1970: timestamp)
            toOpen = notes.filter { $0.event.startDate == meetingTime }
        } else {
            toOpen = notes.filter { $0.event.calendarItemIdentifier == id }
        }
        toOpen.forEach { 
            openNote($0) 
            // TODO: open attachments
        }
    }

    try cleanEmptyNotes()
}

do {
    try main()
} catch {
    print(error)
    print(Thread.callStackSymbols)
    _ = try shell("osascript -e 'display notification \"\(error)\"'")
}
