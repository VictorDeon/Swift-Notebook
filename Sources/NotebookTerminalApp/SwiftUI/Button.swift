import SwiftUI
import ArgumentParser

struct ButtonCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "buttons",
        abstract: "Botões com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(ContentView(), title: "Botões")
            app.run()

            print("Finalizado!")
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Tap Button", action: {
                print("Cliquei no botão 01")
            })
            Button(action: {
                print("Cliquei no botão 02")
            }) {
                HStack {
                    Image(systemName: "person.circle")
                    Text("Clique Aqui!")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                }
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

