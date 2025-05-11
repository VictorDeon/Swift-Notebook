// Vamos criar uma constantes com o struct

import AppKit
import ArgumentParser

struct ConstantCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "constants",
        abstract: "Tutorial sobre constants em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print(Constants.apiKey)
        print(Constants.Metadata.version)
    }
}

struct Constants {
    static let apiKey = "YOUR_API_KEY_HERE"
    struct Metadata {
        static let appName = "notebook"
        static let version = 1.0
    }
}
