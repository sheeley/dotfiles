#!/usr/bin/env xcrun swift
import Foundation
import System

let contentPrefix = """
#!/usr/bin/env bash\n\n
# GENERATED FILE, DO NOT TOUCH
# Edit plist_export or create a file without generated.sh in its name.
"""
let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
let outputDirectory = homeDirectory.appendingPathComponent(".local/share/chezmoi/bin/plists", isDirectory: true)
let outputFilePrefix = "run_once_after_"
let outputFileSuffix = ".generated.sh"

enum MachineType {
    case all, personal, work
}

struct Filters {
    var exclude: [String] = []
    var forceInclude: [String] = []

    func andFilters(_ filters: Filters? = nil) -> Filters {
        guard let filters = filters else { return self }
        return Filters(exclude: exclude + filters.exclude, forceInclude: forceInclude + filters.forceInclude)
    }

    func andFilters(exclude: [String]? = nil, forceInclude: [String]? = nil) -> Filters {
        return Filters(exclude: self.exclude + (exclude ?? []), forceInclude: self.forceInclude + (forceInclude ?? []))
    }

    static let `default` = Filters(exclude: [
        "SU*",
        "NSStatusItem Preferred Position *",
        "last-analytics-stamp",
        "NoSync*",
        "NSWindow Frame*",
        "NSToolbar*",
        "FRFeedbackReporter*",
    ],
    forceInclude: [
        "SUAutomaticallyUpdate",
    ])
}

struct ApplicationConfig {
    var domain: String
    var machineType: MachineType = .all
    var applicationToRestart: String? = nil
    var currentHost: Bool = false
    var filters: Filters? = nil
}

extension ApplicationConfig {
    static func filtered(_ domain: String, machineType: MachineType = .all, restart applicationToRestart: String? = nil, currentHost: Bool = false, filters: Filters? = nil) -> ApplicationConfig {
        return ApplicationConfig(domain: domain, machineType: machineType, applicationToRestart: applicationToRestart, currentHost: currentHost, filters: filters)
    }

    static func all(_ domain: String, machineType: MachineType = .all, restart applicationToRestart: String? = nil, currentHost: Bool = false) -> ApplicationConfig {
        return ApplicationConfig(domain: domain, machineType: machineType, applicationToRestart: applicationToRestart, currentHost: currentHost)
    }

    static func `default`(_ domain: String, machineType: MachineType = .all, restart applicationToRestart: String? = nil, currentHost: Bool = false, andFilters additionalFilters: Filters? = nil) -> ApplicationConfig {
        return ApplicationConfig(domain: domain, machineType: machineType, applicationToRestart: applicationToRestart, currentHost: currentHost, filters: .default.andFilters(additionalFilters))
    }

    static func only(_ domain: String, machineType: MachineType = .all, restart applicationToRestart: String? = nil, currentHost: Bool = false, include: [String]) -> ApplicationConfig {
        return ApplicationConfig(domain: domain, machineType: machineType, applicationToRestart: applicationToRestart, currentHost: currentHost, filters: Filters(exclude: ["*"], forceInclude: include))
    }
}

extension ApplicationConfig {
    func outputFile() -> URL {
        let currentHostSuffix = currentHost ? ".currentHost" : ""
        return outputDirectory.appendingPathComponent("\(outputFilePrefix)\(domain)\(currentHostSuffix)\(outputFileSuffix)", isDirectory: false)
    }

    // func content() -> String {
    //     guard let d = UserDefaults(suiteName: domain) else {
    //         print("nil")
    //         return "# No suite found for '\(domain)'"
    //     }
    //     let dictVersion = d.dictionaryRepresentation()
    //     for key in dictVersion.keys {
    //         guard let value = dictVersion[key] else { continue }
    //         let t = type(of: value)
    //         switch t {
    //         case is Bool:
    //             print("bool")
    //         default:
    //             print(key, t)
    //         }
    //     }
    //     return ""
    // }

    func content() -> String {
        var output = contentPrefix
        var args: [String] = []
        if currentHost {
            args.append("-currentHost")
        }
        args += ["read", domain]

        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = args
        task.standardError = pipe
        task.standardOutput = pipe
        task.launch()
        // task.waitUntilExit()
        let exclusions = [NSRegularExpression]()
        let forceKeep = [NSRegularExpression]()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let commandOutput = String(data: data, encoding: .utf8) {
            do {
                print(domain)
                let settings = try PropertyListSerialization.propertyList(from: commandOutput.data(using: .utf8)!, format: nil) as! [String: Any]
                // do something with the dictionary
                let validKeys = settings.keys.filter { key in
                    let fullRange = NSRange(key.startIndex ..< key.endIndex, in: key)
                    for exclude in exclusions {
                        guard exclude.firstMatch(in: key, range: fullRange) != nil else {
                            continue
                        }

                        for keep in forceKeep {
                            if exclude.firstMatch(in: key, range: fullRange) != nil {
                                return true
                            }
                        }
                        print("filtering out: \(key)")
                        return false
                    }
                    return true
                }
                for key in validKeys {
                    print("->\(key)")
                }
            } catch {
                print("=> \(error)")
            }
            output += commandOutput.replacingOccurrences(of: homeDirectory.absoluteString, with: "~")
        }

        if let applicationToRestart = applicationToRestart, !applicationToRestart.isEmpty {
            output += "\nstart_application -r -a \"\(applicationToRestart)\""
        }
        // cmd = [
        //     DS_PATH,
        //     "-d",
        //     domain,
        // ]
        // # def wrap_quote(arg):
        //     #     if "*" in arg or " " in arg:
        //     #         return f"'{arg}'"
        //     #    return arg
        //     # wrapped_cmd = map(wrap_quote, cmd)
        //     # print(" ".join(wrapped_cmd), "\n", file_name, "\n")
        //     command = run(cmd, capture_output=True)
        //     command.check_returncode()
        return output
    }
}

var configs: [ApplicationConfig] = [
    .default("ai.krisp.krispMac"),
    .default("codes.rambo.AirBuddy", restart: "AirBuddy"),
    .default("com.abhishek.Clocker", restart: "Clocker", andFilters: Filters(exclude: ["iVersionLastChecked"])),
    .default("com.apple.controlcenter", restart: "Control Center"),
    .default("com.apple.dock", restart: "Dock", andFilters: Filters(exclude: ["mod-count", "trash-full"])),
    .filtered("com.apple.finder", restart: "Finder", filters: Filters(exclude: [
        "FXRecentFolders",
        "FXSidebarUpgraded*",
        "FavoriteTagNames",
        "GoToField",
        "GoToFieldHistory",
        "LastTrashState",
        "RecentMoveAndCopyDestinations",
        "QuickLookPreview*",
        "NewWindowTargetPath",
        "FXPreferencesWindow..*",
    ])),
    .only("com.apple.screencapture", restart: "SystemUIServer", include: ["location"]),
    .all("com.apple.symbolichotkeys"),
    .default("com.googlecode.iterm2"),
    .filtered("com.if.Amphetamine", restart: "Amphetamine", filters: Filters(exclude: ["Session Durations", "Total Session Run Time"])),
    .default("com.omnigroup.OmniFocus3", andFilters: Filters(exclude: [
        "LastArchiveRequestTimeInterval",
        "LastAutomaticBackupDate",
        "LastAutomaticBackupTailTransactionIdentifier",
        "LastExportDirectory",
    ])),
    .default("com.sourcegear.DiffMerge"),
    .only("com.surteesstudios.Bartender", restart: "Bartender 4", include: [
        "SUAutomaticallyUpdate",
        "ShowForUpdateSettings",
        "ProfileSettings",
        "UseBartenderBar",
        "appSettings",
        "statusBarImageNamed",
        "license2HoldersName",
        "license4HoldersName",
    ]),
    .default("org.shiftitapp.ShiftIt", restart: "ShiftIt"),
    .only("com.apple.Safari", include: [
        "AlwaysRestoreSessionAtLaunch",
        "AutoFillPasswords",
        "FindOnPageMatchesWordStartsOnly",
        "HomePage",
        "IncludeDevelopMenu",
        "SearchProviderIdentifier",
        "ShowFavoritesBar-v2",
        "ShowOverlayStatusBar",
        "ShowSidebarInNewWindows",
        "ShowSidebarInTopSites",
        "SidebarViewModeIdentifier",
        "UniversalSearchEnabled",
        "WebKitDeveloperExtrasEnabledPreferenceKey",
        "WebKitPreferences.*",
    ]),
    .only("NSGlobalDomain", include: [
        "AppleActionOnDoubleClick",
        "AppleMiniaturizeOnDoubleClick",
        "AppleScrollerPagingBehavior",
        "AppleShowAllExtensions",
        "NSAutomaticCapitalizationEnabled",
        "NSAutomaticDashSubstitutionEnabled",
        "NSAutomaticPeriodSubstitutionEnabled",
        "NSAutomaticQuoteSubstitutionEnabled",
        "NSAutomaticSpellingCorrectionEnabled",
        "NSAutomaticTextCompletionEnabled",
        "NSQuitAlwaysKeepsWindows",
        "NSUserDictionaryReplacementItems",
        "WebAutomaticSpellingCorrectionEnabled",
        "com.apple.mouse.scaling",
        "com.apple.sound.beep.flash",
        "com.apple.sound.beep.volume",
        "com.apple.sound.uiaudio.enabled",
        "com.apple.springing.delay",
        "com.apple.springing.enabled",
        "com.apple.trackpad.forceClick",
    ]),
    .only("NSGlobalDomain", currentHost: true, include: [
        "AppleActionOnDoubleClick",
        "AppleAntiAliasingThreshold",
        "AppleInterfaceStyle",
        "AppleInterfaceStyleSwitchesAutomatically",
        "AppleMiniaturizeOnDoubleClick",
        "AppleScrollerPagingBehavior",
        "AppleShowAllExtensions",
        "NSAutomaticCapitalizationEnabled",
        "NSAutomaticDashSubstitutionEnabled",
        "NSAutomaticPeriodSubstitutionEnabled",
        "NSAutomaticQuoteSubstitutionEnabled",
        "NSAutomaticSpellingCorrectionEnabled",
        "NSAutomaticTextCompletionEnabled",
        "NSPreferredWebServices",
        "NSQuitAlwaysKeepsWindows",
        "WebAutomaticSpellingCorrectionEnabled",
        "com.apple.mouse.scaling",
        "com.apple.sound.beep.flash",
        "com.apple.sound.beep.volume",
        "com.apple.sound.uiaudio.enabled",
        "com.apple.springing.delay",
        "com.apple.springing.enabled",
        "com.apple.trackpad.forceClick",
    ]),
    .only("com.agilebits.onepassword7", restart: "1Password 7", include: [
        "OPPrefShowSafariInlineMenu",
        "OPPrefShowSafariInlineMenuAutomatically",
        "OPPreferencesNotifyCompromisedWebsites",
        "ShortcutRecorder BrowserActivation",
        "ShortcutRecorder GlobalActivation",
        "ShortcutRecorder GlobalLock",
    ]),
    .only("net.shinyfrog.bear", restart: "Bear", include: [
        "SFAppIconMatchesTheme",
        "SFAppThemeName",
        "SFAutoGrabURLTitles",
        "SFEditorLineWidthMultiplier",
        "SFFirstLaunchNotes",
        "SFFoldCompletedTodo",
        "SFNoteTextViewAutomaticSpellingCorrectionEnabled",
        "SFNoteTextViewContinuousSpellCheckingEnabled",
        "SFNoteTextViewGrammarCheckingEnabled",
        "SFTagsListSortAscending",
        "SFTagsListSortBy",
    ]),
]

for config in configs {
    do {
        let file = config.outputFile()
        // try config.content().write(to: file, atomically: true, encoding: .utf8)

        let fd = try FileDescriptor.open(file.path, .writeOnly, options: .truncate, permissions: FilePermissions(rawValue: 0o755))
        _ = try fd.closeAfter { try fd.writeAll(config.content().utf8) }
        print("wrote \(file)")
    } catch {
        print(error)
    }
}
