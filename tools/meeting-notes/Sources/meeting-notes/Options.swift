//
//  File.swift
//  
//
//  Created by Johnny Sheeley on 11/29/23.
//

import Foundation
import ArgumentParser

enum DeleteWindow: String, CaseIterable {
    case past, future, all, none

    func includes(date: Date) -> Bool {
//        print("\(self) \(Date()) \(date)")
        switch self {
        case .none:
            return false
        case .past:
            return date < Date() // startOfToday
        case .future:
            return date > Date() // endOfToday
        case .all:
            return true
        }
    }
}

extension DeleteWindow: ExpressibleByArgument {}

struct GlobalOptions: ParsableArguments, CustomStringConvertible {
    var description: String {
        """
        ---
        baseDirectory:\t\(baseDirectory)
        vaultName:\t\(vaultName)
        subDirectory:\t\(subDirectory)
        clean:\t\(clean)
        openNoteID:\t\(openNoteID ?? "")
        ---
        """
    }

    @Option(name: .long, help: "Directory to create notes in")
    var baseDirectory: String = FileManager.default
        .homeDirectoryForCurrentUser
        .appending(components: "Library/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes")
        .path(percentEncoded: false)

    @Option(name: .long, help: "Vault to open notes in")
    var vaultName = "Apple Notes"

    @Option(name: .long, help: "'today', 'tomorrow', 'both', or a specific note ID")
    var create: String?

    @Option(name: .long, help: "Subdirectory to use")
    var subDirectory = ""

    @Option(name: .long, help: ArgumentHelp(DeleteWindow.allCases.map { $0.rawValue }.joined(separator: ", ")))
    var clean = DeleteWindow.none

    @Option(name: .long, help: "ID of note to open")
    var openNoteID: String?

    @Flag
    var verbose = false

    @Flag
    var interactive = false

    @Flag
    var dryRun = false

    @Flag
    var force = false
}
