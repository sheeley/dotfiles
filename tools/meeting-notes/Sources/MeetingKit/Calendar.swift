//
//  Calendar.swift
//
//
//  Created by Johnny Sheeley on 11/18/22.
//

import EventKit
import Foundation

// MARK: - Calendar

let store = EKEventStore()

public func requestAccess() throws {
    let sema = DispatchSemaphore(value: 0)
    store.requestFullAccessToEvents { allowed, err in
        guard allowed, err == nil else {
            print("Calendar access not allowed:\n\(String(describing: err))")
            exit(1)
        }
        sema.signal()
    }
    _ = sema.wait(timeout: .distantFuture)
}

public enum EventWindow {
    case today, tomorrow, either, specificEvent(id: String)

    func includes(event: EKEvent) -> Bool {
        switch self {
        case .today:
            return Calendar.current.isDateInToday(event.startDate)
        case .tomorrow:
            return Calendar.current.isDateInTomorrow(event.startDate)
        case .either:
            return Calendar.current.isDateInToday(event.startDate) || Calendar.current.isDateInTomorrow(event.startDate)
        case let .specificEvent(id):
            return event.calendarItemIdentifier == id
        }
    }
}

public func getEvents(in window: EventWindow) -> [EKEvent] {
    switch window {
    case let .specificEvent(id):
        if let event = store.event(withIdentifier: id) {
            return [event]
        }
        return []
    default:
        let today = Date().beginning(of: .day)!
        let tomorrow = Date().end(of: .day)!

        let predicate = store.predicateForEvents(withStart: today, end: tomorrow, calendars: nil)
        let events = store.events(matching: predicate)
        return events.filter { event in
            guard event.attendees?.count ?? 0 > 1 else { return false }
            guard !event.isAllDay else { return false }
            guard eventFilter(event) else { return false }
            return window.includes(event: event)
        }
    }
}
