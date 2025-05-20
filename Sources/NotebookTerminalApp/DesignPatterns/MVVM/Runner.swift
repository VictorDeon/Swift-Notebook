// MVVM = Model <-Notify-> ViewModel <-Binding-> View

import AppKit
import ArgumentParser

struct MVVMCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "mvvm",
        abstract: "Tutorial sobre o padrão de projeto MVVM em swift"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(CounterView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}
