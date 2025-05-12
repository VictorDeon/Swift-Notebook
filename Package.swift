// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotebookTerminalApp",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "NotebookTerminalApp", targets: ["NotebookTerminalApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "7.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "NotebookTerminalApp",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GRDB", package: "GRDB.swift")
            ]
        )
    ]
)
