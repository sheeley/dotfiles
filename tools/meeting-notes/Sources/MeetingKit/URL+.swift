//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/18/22.
//

import Foundation

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
