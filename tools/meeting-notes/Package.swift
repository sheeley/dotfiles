// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "meeting-notes",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .target(name: "MeetingKit"),
        .target(name: "NoteKit"),
        .executableTarget(
            name: "meeting-notes",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "MeetingKit",
                "NoteKit"
            ]
        ),
        .testTarget(
            name: "meeting-notesTests",
            dependencies: ["meeting-notes"]),
        .testTarget(
            name: "MeetingKitTests",
            dependencies: ["MeetingKit"]),
        .testTarget(
            name: "NoteKitTests",
            dependencies: ["NoteKit"]),
    ]
)
