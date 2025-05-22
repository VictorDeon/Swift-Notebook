import SwiftUI
import ArgumentParser

struct EnvironmentObjectCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "environment-object",
        abstract: "Environment Object com Swift UI. Muito parecido com o REDUX"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            let redux = CounterRedux()
            TerminalApp.showWindow(ContentViewRoot().environmentObject(redux), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate class CounterRedux: ObservableObject {
    @Published var counter: Int = 0
}

fileprivate struct ContentViewRoot: View {

    @EnvironmentObject var state: CounterRedux
    
    private func incremet() {
        state.counter += 1
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            Text("\(state.counter)").font(.largeTitle)
            Button(action: incremet) {
                Text("Increase Counter")
            }
            Spacer()
            AnotherContentView()
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct AnotherContentView: View {
    
    @EnvironmentObject var state: CounterRedux
    
    private func incremet() {
        state.counter += 1
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            Text("\(state.counter)").font(.largeTitle)
            Button(action: incremet) {
                Text("Increase Counter")
            }
        }
        .padding(10)
    }
}
