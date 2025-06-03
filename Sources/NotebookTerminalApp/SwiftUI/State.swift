import SwiftUI
import ArgumentParser
import VKSwiftUI

struct StateCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "state",
        abstract: "State com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalSwiftUI.showWindow(StateContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct StateContentView: View {
    
    @State private var counter: Int = 0
    
    private func incremet() {
        counter += 1
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            Text("\(counter) from state view")
            Button(action: incremet) {
                Text("Increase Counter")
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}
