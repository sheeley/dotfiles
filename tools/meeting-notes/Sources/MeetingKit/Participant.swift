//
//  File 2.swift
//
//
//  Created by Johnny Sheeley on 11/18/22.
//

import EventKit
import Foundation

public struct Participant: CustomStringConvertible {
    public let name: String
    public let email: String

    public var description: String {
        return name
    }
}

func participants(from attendees: [EKParticipant]?) -> [Participant] {
    guard let attendees else { return [] }
    var seen = Set<String>()

    return attendees.compactMap { a in
        guard let name = a.name else { return nil }
        guard attendeeFilter(name) else { return nil }
        guard !seen.contains(name) else { return nil }
        seen.insert(name)

        return Participant(name: name.replacingOccurrences(of: " (V)", with: ""),
                           email: "")
    }
}
