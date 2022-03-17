#!/usr/bin/env xcrun swift
// #! /usr/bin/env swift
import Foundation
import EventKit
import System

let subdir = "apple"

func titleModifier(_ title: String?) -> String {
    guard var title = title else { return "" }
    if let range = title.range(of: #"(( ?/ ?Johnny)|(Johnny ?/? ?))"#, options: .regularExpression) {
        title = title.replacingCharacters(in: range, with: "")
        if !title.contains("1o1") && !title.contains("1:1") {
            title += " 1o1"
        }
    }
    return title.replacingOccurrences(of: "/", with: "-")
}

func attendeeFilter(_ name: String) -> Bool {
    guard !name.starts(with: "Virtual") && name != "Johnny Sheeley" else { return false }
    return true
}

func eventFilterFunc(_ event: EKEvent) -> Bool {
    guard let title = event.title, !title.contains("Status") else { return false }
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
    n.enumerateLines { l, _  in
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

enum eventFilter: String {
    case today, tomorrow
}

let store = EKEventStore()

func requestAccess() throws {
    let sema = DispatchSemaphore(value: 0)
    store.requestAccess(to: .event) { allowed, err in
        guard allowed && err == nil else { exit(1) }
        sema.signal()
    }
    _ = sema.wait(timeout: .distantFuture)
}

func getEvents(_ filter: eventFilter) -> [EKEvent] {
    let today = Date()
    let tomorrow = Date().addingTimeInterval(60 * 60 * 24)
    let predicate = store.predicateForEvents(withStart: today, end: tomorrow, calendars: nil)
    let events = store.events(matching: predicate)
    return events.filter { event in
        guard event.attendees?.count ?? 0 > 1 else { return false }
        guard !event.isAllDay else { return false }
        guard eventFilterFunc(event) else { return false }

        switch filter {
        case .today:
            return Calendar.current.isDateInToday(event.startDate)
        case .tomorrow:
            return Calendar.current.isDateInTomorrow(event.startDate)
        }
    }
}

struct Note {
    let path: URL
    let contents: String
}

func format(_ event: EKEvent, withTemplate template: String, andPath dir: URL) -> Note {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH-mm"
    let dateTime = df.string(from: event.startDate)

    let title = titleModifier(event.title)
    let notePath = dir.appendingPathComponent("\(dateTime) - \(title).md")

    var attendeeText = ""
    if let attendees = event.attendees {
        attendeeText = "attendees:\n"
        attendeeText += attendees.map { a in
            guard let name = a.name else { return "" }
            guard attendeeFilter(name) else { return "" }
            return "  - \"[[\(name.replacingOccurrences(of: " (V)", with: ""))]]\"\n"
        }.joined()
    }

    if let url = event.url {
        attendeeText += "\nurl: \(url.path)\n"
    }

    var text = template
    .replacingOccurrences(of: "attendees: ", with: "attendees:")
    .replacingOccurrences(of: "attendees:\n  - \"[[]]\"", with: attendeeText)
    .replacingOccurrences(of: "{{date:YYYY-MM-DD HH:mm:ss}}", with: dateTime)

    text = text.replacingOccurrences(of: "{{notes}}", with: noteFilter(event.notes))

    return Note(path: notePath, contents: text)
}

func summarize(_ u: URL, _ f: eventFilter, _ allNotes: [Note], _ toCreate: [Note]) {
    let prefix = u.absoluteString
    print("Found \(allNotes.count) events for \(f.rawValue), will create \(toCreate.count):")
    toCreate.forEach{ 
        print($0.path.absoluteString.replacingOccurrences(of: prefix, with: "").replacingOccurrences(of: "%20", with: " ")) 
        // print($0.contents)
        // print("")
    }
}

func main() throws {
    let args = CommandLine.arguments
    var filter = eventFilter.today
    if args.count == 2 {
        filter = eventFilter(rawValue: args[1]) ?? filter
    }

    try requestAccess()

    guard let notesDir = ProcessInfo.processInfo.environment["NOTES_DIR"] else {
        print("$NOTES_DIR not set")
        return
    }

    let notesURL = URL(fileURLWithPath: notesDir)
    let template = try String(contentsOfFile: "\(notesDir)/shared/templates/meeting.md")

    let events = getEvents(filter)
    let notes = events.map { format($0, withTemplate: template, andPath: notesURL.appendingPathComponent(subdir))}

    var written = [Note]()

    let toCreate = notes.filter { !FileManager.default.fileExists(atPath: $0.path.path) }
    summarize(notesURL, filter, notes, toCreate)

    if toCreate.isEmpty {
        return
    }

    print("Continue? [y/N]")
    let input = readLine()
    if input?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "y" {
        return
    }

    try toCreate.forEach { n in
        guard !FileManager.default.fileExists(atPath: n.path.path) else {
            print("\(n.path) exists, skipping")
            return
        }
        guard let d = n.contents.data(using: .utf8) else {
            print("\(n.path) couldn't convert to data")
            return
        }

        try d.write(to: n.path)
        written.append(n)
    }
}
try main()
