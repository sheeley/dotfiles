//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/18/22.
//

import Foundation

extension Date {
    init(_ year: Int, _ month: Int, _ day: Int, hour: Int? = nil, minute: Int? = nil) {
        let cal = Calendar.current
        //        cal.timeZone = TimeZone(identifier: "UTC")!
        let components = DateComponents(calendar: cal, year: year, month: month, day: day, hour: hour, minute: minute)
        self = components.date!
    }
}
