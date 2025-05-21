import SwiftUI
import ArgumentParser

struct StateCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "state",
        abstract: "State e Binding com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(StateContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct StateContentView: View {
    
    @State private var counter: Int = 0
    
    var body: some View {
        VStack {
            Text("\(counter) from state view")
            // Passando o counter como binding para que a subview possa observa-lo e modifica-lo.
            BindingContentView(counter: $counter)
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct BindingContentView: View {
    
    @Binding var counter: Int
    
    // Não é obrigatorio criar, mas é bom saber
    init(counter: Binding<Int>) {
        // Observe: usamos o under-score para atribuir ao wrapper
        self._counter = counter
    }
    
    private func incremet() {
        counter += 1
    }
    
    var body: some View {
        Text("\(counter) from binding view")
        Button(action: incremet) {
            Text("Increase Counter")
        }
    }
}
