//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/18/22.
//

import Foundation
import EventKit

// MARK: - Calendar
let store = EKEventStore()

public func requestAccess() throws {
    let sema = DispatchSemaphore(value: 0)
    store.requestAccess(to: .event) { allowed, err in
        guard allowed, err == nil else { exit(1) }
        sema.signal()
    }
    _ = sema.wait(timeout: .distantFuture)
}

public func getEvents() -> [EKEvent] {
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
