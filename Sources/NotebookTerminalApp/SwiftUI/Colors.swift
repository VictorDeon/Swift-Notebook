import SwiftUI
import ArgumentParser

struct ColorCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "colors",
        abstract: "Colors com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(ColorContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct ColorContentView: View {
    var body: some View {
        VStack(spacing: 15) {
            Color.green
            Color(nsColor: NSColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1))
        }.padding(10)
    }
}

