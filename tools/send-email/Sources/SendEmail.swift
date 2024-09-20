// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import SwiftSMTP

struct Config: ParsableArguments {
    @Option(name: .long, help: "SMTP Settings file")
    var settingsFile: String = FileManager.default.homeDirectoryForCurrentUser.path() + "/.smtp.json"

    @Option(name: .long, help: "Destination email")
    var to: String = ""

    @Option(name: .long, help: "Source email")
    var from: String = ""

    @Option(name: .long, help: "Email subject")
    var subject: String = ""

    @Option(name: .long, help: "Email body")
    var text: String = ""

    @Option(name: .long, help: "Files to attach")
    var attachment: String? = nil

    @Option(name: .long, help: "Source name")
    var fromName: String? = nil
}

struct SMTPSettings: Decodable {
    var hostname: String
    var email: String
    var password: String
}

struct missingSettingsError: Error {}

@main
struct MailCommand: ParsableCommand {
    @OptionGroup
    var config: Config

    func run() throws {
        guard let smtpConfigData = FileManager.default.contents(atPath: config.settingsFile) else {
            throw missingSettingsError()
        }
        let smtpConfig = try JSONDecoder().decode(SMTPSettings.self, from: smtpConfigData)

        let smtp = SMTP(
            hostname: smtpConfig.hostname,
            email: smtpConfig.email,
            password: smtpConfig.password
        )

//        let fileAttachments = config.attachments?.map {
//            Attachment(filePath: $0)
//        } ?? []

        var fileAttachments = [Attachment]()
        if let attachment = config.attachment {
            fileAttachments.append(Attachment(filePath: attachment))
        }

        let to = config.to.isEmpty ? smtpConfig.email : config.to
        let from = config.from.isEmpty ? smtpConfig.email : config.from

        let mail = Mail(
            from: Mail.User(name: config.fromName, email: from),
            to: [Mail.User(email: to)],
            subject: config.subject,
            text: config.text,
            attachments: fileAttachments
        )

        let sema = DispatchSemaphore(value: 0)
        smtp.send(mail) { error in
            if let error = error {
                print(error)
            }
            sema.signal()
        }
        _ = sema.wait(timeout: .distantFuture)
    }
}
