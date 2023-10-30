//
//  YAML.swift
//  
//
//  Created by Johnny Sheeley on 10/10/23.
//

import Foundation

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
        return "\n" + map { "  - \($0.fmstring())" }.joined(separator: "\n")
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
