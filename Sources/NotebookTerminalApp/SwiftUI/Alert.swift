import SwiftUI
import ArgumentParser

struct AlertCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "alert",
        abstract: "Alert com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(AlertContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct AlertContentView: View {
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button("Entrar", action: { showAlert = true })
            }
            .padding(10)
            .frame(width: 300, height: 300, alignment: .center)
        }
        .alert("Sign Up Completed", isPresented: $showAlert) {
            Button("OK", action: {
                showAlert = false
            })
        } message: {
            Text("Seja bem vindo a plataforma!")
        }

    }
}
