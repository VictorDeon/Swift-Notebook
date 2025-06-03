import SwiftUI
import ArgumentParser
import VKSwiftUI

struct EnvironmentCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "environment",
        abstract: "Environment com Swift UI. São configurações que a apple já disponibiliza para gente."
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalSwiftUI.showWindow(
                ContentViewRoot()
                    .environment(\.layoutDirection, .leftToRight),
                by: app
            )
            app.run()

            print("Finalizado!")
        }
    }
}


fileprivate struct ContentViewRoot: View {
    
    @State private var isPresented: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text(colorScheme == .dark ? "DARK" : "LIGHT")
            Button("Open Sheet") {
                isPresented = true
            }
        }
        .padding(10)
        .sheet(isPresented: $isPresented) {
            AddView()
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Add View")
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}
