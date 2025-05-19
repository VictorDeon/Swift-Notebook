// SwiftUI Hello World
import SwiftUI
import ArgumentParser

struct SwiftUIHelloWorldCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "hello-world",
        abstract: "Hello World com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .long,  // --title1
        help: "Título da primeira Janela"
    )
    var title1: String = "Janela 1"

    @Option(
        name: .long,  // title2
        help: "Título da segunda Janela"
    )
    var title2: String = "Janela 2"

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(ContentView1(), title: title1)
            app.run()

            TerminalApp.showWindow(ContentView2(), title: title2)
            app.run()

            print("Finalizado!")
        }
    }
}

struct ContentView1: View {
    var body: some View {
        Text("Ola mundo 01!")
            .padding()
            .frame(width: 500, height: 200)
    }
}

struct ContentView2: View {
    var body: some View {
        Text("Ola mundo 02!")
            .padding()
            .frame(width: 300, height: 100)
    }
}
