//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/18/22.
//

import Foundation
import EventKit

public struct Meeting {
    public let startDate: Date
    public let endDate: Date
    public let title: String
    public let id: String
    public let attendees: [Participant]
    public let notes: String
    public let url: URL?
    //    let urls: [URL]
    
    public func note(with template: String) -> String {
        var template = template
        let dateTime = df.string(from: startDate)
        let attendeeLinks = attendees.map { MarkdownLink(text: $0.name) }
        
        var frontmatter = Frontmatter()
        frontmatter["attendees"] = attendeeLinks
        frontmatter["id"] = id
        frontmatter["title"] = titleModifier(title)
        frontmatter["record"] = "meeting"
        if let url = url, !url.isVideoChatHost {
            frontmatter["url"] = url.absoluteString
        }
        template = template.replacingOccurrences(of: "record: meeting\n", with: "")
        let idx = template.firstRange(of: "---\n")?.upperBound ?? template.startIndex
        var fms = frontmatter.string() + "\n"
        if idx == template.startIndex {
            fms = "---\n\(fms)\n---\n"
        }
        template.insert(contentsOf: fms, at: idx)
        
        return template
            .replacingOccurrences(of: "{{date:YYYY-MM-DD HH:mm:ss}}", with: dateTime)
            .replacingOccurrences(of: "{{notes}}", with: noteFilter(notes))
            .replacingOccurrences(of: "{{title}}", with: titleModifier(title))
            .replacingOccurrences(of: "{{id}}", with: id)
            .replacingOccurrences(of: "{{attendees}}", with: attendeeLinks.map { $0.string() }.joined(separator: "\n"))
    }
    
    public func filename() -> String {
        let dateTime = df.string(from: startDate)
        var filename = titleModifier(title)
        filename.unicodeScalars.removeAll(where: { fileNameCharacters.contains($0) })
        return "\(dateTime) - \(filename).md"
    }
    
    public func fullPath(dir: URL) -> URL {
        return dir.appendingPathComponent(filename())
    }
}

public extension Meeting {
    init(from event: EKEvent) {
        self.init(startDate: event.startDate,
                  endDate: event.endDate,
                  title: event.title,
                  id: event.eventIdentifier,
                  attendees: participants(from: event.attendees),
                  notes: event.notes ?? "",
                  url: event.url)
    }
}

public extension Array where Element == Meeting {
    func humanReadable() -> String {
        return self.map {
            """
\($0.title)
\($0.id)
\(df.string(from: $0.startDate)) - \(df.string(from: $0.endDate))
"""
        }.joined(separator: "\n")
    }
}

var df: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH-mm"
    return df
}()

var fileNameCharacters: CharacterSet {
    var fileNameCharacters = NSCharacterSet.punctuationCharacters
    fileNameCharacters.remove(charactersIn: "-_.")
    return fileNameCharacters
}

// MARK: - Filters and Modifiers

public func titleModifier(_ title: String?) -> String {
    guard var title = title else { return "" }
    if let range = title.range(of: #"(( ?/ ?Johnny)|(Johnny ?/? ?))"#, options: .regularExpression) {
        title = title.replacingCharacters(in: range, with: "")
        if !title.contains("1o1"), !title.contains("1:1") {
            title += " 1o1"
        }
    }
    return title
}

public func attendeeFilter(_ name: String) -> Bool {
    guard !name.starts(with: "Virtual"), name != "Johnny Sheeley" else { return false }
    return true
}

public func eventFilter(_ event: EKEvent) -> Bool {
    guard event.hasAttendees else { return false }
    if let me = event.attendees?.filter({ $0.isCurrentUser }).first, me.participantStatus == .declined {
        return false
    }
    // guard let title = event.title, !title.contains("Status") else { return false }
    return true
}

public func noteFilter(_ notes: String?) -> String {
    guard var notes = notes else { return "" }
    notes = filterOutWebex(notes)
    guard !notes.isEmpty else { return "" }
    return "---\n\(notes)\n---"
}

public func filterOutWebex(_ n: String) -> String {
    var out = ""
    var ignoreLine = false
    n.enumerateLines { l, _ in
        if ignoreLine {
            if l == "---===---" {
                ignoreLine = false
            }
            return
        } else if l == "----( Virtual Conference One-Time Room )----" ||  l == "----( Virtual Conference Personal Room )----"{
            ignoreLine = true
            return
        }
        out += "\(l)\n"
    }
    return out
}

struct MarkdownLink: YAMLOut {
    let text: String
    
    func string() -> String {
        return "[[\(text)]]"
    }
    
    func fmstring() -> String {
        return "\"[[\(text)]]\""
    }
}

protocol YAMLOut {
    func fmstring() -> String
    var isMultiline: Bool { get }
}

extension YAMLOut {
    var isMultiline: Bool { false }
}

extension String: YAMLOut {
    func fmstring() -> String {
        return self
    }
}
extension Array: YAMLOut where Element: YAMLOut {
    var isMultiline: Bool { true }
    func fmstring() -> String {
        return "\n" + self.map { "  - \($0.fmstring())"}.joined(separator: "\n")
    }
}

struct Frontmatter {
    var kv = [String: YAMLOut]()
    
    subscript(key: String) -> YAMLOut? {
        get {
            kv[key]
        }
        
        set(newValue) {
            kv[key] = newValue
        }
    }
    
    func string() -> String {
        var lines = [String]()
        for key in kv.keys.sorted() {
            guard let value = kv[key] else { continue }
            
            var line = key
            line.append(":")
            if !value.isMultiline {
                line.append(" ")
            }
            line.append(value.fmstring())
            
            lines.append(line)
        }
        return lines.joined(separator: "\n")
    }
}
