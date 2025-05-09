// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotebookTerminalApp",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0")
    ],
    targets: [
        .executableTarget(
            name: "NotebookTerminalApp",
            dependencies: ["Alamofire"]
        )
    ]
)
