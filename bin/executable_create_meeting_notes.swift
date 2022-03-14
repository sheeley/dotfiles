#!/usr/bin/env xcrun swift
// #! /usr/bin/env swift
import Foundation
import EventKit
import System

let subdir = "apple"

enum eventFilter: String {
    case current, next, today, tomorrow
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
        var first = false
        return events.filter { event in
            guard event.attendees?.count ?? 0 > 1 else { return false }
            guard !event.isAllDay else { return false }
            
            switch filter {
            case .current:
                if !first && event.startDate < Date() && event.endDate > Date() {
                    first = true
                    return true
                }
            case .next:
                if !first && event.startDate > Date() {
                    first = true
                    return true
                }
            case .today:
                return Calendar.current.isDateInToday(event.startDate)
            case .tomorrow:
                return Calendar.current.isDateInTomorrow(event.startDate)
            }
            return false
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
    
    let title = event.title?.replacingOccurrences(of: "/", with: "-") ?? "Untitled" // TODO: clean
    let notePath = dir.appendingPathComponent("\(dateTime) - \(title).md") // TODO: make configurable
    
    var attendeeText = ""
    if let attendees = event.attendees {
        attendeeText = "attendees:\n"
        attendeeText += attendees.map { a in
            guard let name = a.name else { return "" }
            guard !name.starts(with: "Virtual") && name != "Johnny Sheeley" else { return "" }
            return "  - \"[[\(name.replacingOccurrences(of: " (V)", with: ""))]]\"\n"
        }.joined()
    }
    let text = template
        .replacingOccurrences(of: "attendees: ", with: "attendees:")
        .replacingOccurrences(of: "attendees:\n  - \"[[]]\"", with: attendeeText)
        .replacingOccurrences(of: "{{date:YYYY-MM-DD HH:mm:ss}}", with: dateTime)
    
    return Note(path: notePath, contents: text)
}

func summarize(_ u: URL, _ f: eventFilter, _ allNotes: [Note], _ toCreate: [Note]) {
    let prefix = u.absoluteString
    print("Found \(allNotes.count) events for \(f.rawValue), will create \(toCreate.count):")
    toCreate.forEach{ print($0.path.absoluteString.replacingOccurrences(of: prefix, with: "").replacingOccurrences(of: "%20", with: " ")) }
    // toCreate.forEach{ print($0.path.absoluteString) }
}

func main() throws {
    let args = CommandLine.arguments
    var filter = eventFilter.tomorrow
    if args.count == 2 {
        filter = eventFilter(rawValue: args[1]) ?? filter
    }
    
    try requestAccess()
    
    guard let notesDir = ProcessInfo.processInfo.environment["NOTES_DIR"] else {
        print("notes dir not set")
        return
    }
    let notesURL = URL(fileURLWithPath: notesDir)
    let template = try String(contentsOfFile: "\(notesDir)/shared/templates/meeting.md")
    
    let events = getEvents(filter)
    let notes = events.map { format($0, withTemplate: template, andPath: notesURL.appendingPathComponent(subdir))}
    
    var written = [Note]()
   
    // notes.forEach { print($0.path.standardized.absoluteString) }
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
        // print("would write \(n.path)")
    }
}
try main()
