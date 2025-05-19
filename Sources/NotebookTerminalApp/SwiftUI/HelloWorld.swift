import SwiftUI
import ArgumentParser

struct SwiftUIHelloWorldCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "hello",
        abstract: "Hello World com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .long,
        help: "Título da Janela"
    )
    var title: String = "Hello World"

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(ContentView(), title: title)
            app.run()

            print("Finalizado!")
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Ola mundo!")
                .padding()
                .frame(width: 500, height: 200)
        }
    }
}

