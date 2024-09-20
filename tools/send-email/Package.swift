// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "send-email",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/Kitura/Swift-SMTP", .upToNextMinor(from: "5.1.0")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "send-email", dependencies: [
                .product(name: "SwiftSMTP", package: "swift-SMTP"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
