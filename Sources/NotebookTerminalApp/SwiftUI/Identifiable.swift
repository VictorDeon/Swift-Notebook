import SwiftUI
import ArgumentParser

struct IdentifiableCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "identifiable",
        abstract: "Identifiable com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            
            TerminalApp.showWindow(IdentifiableStringContent(), by: app)
            app.run()
            
            TerminalApp.showWindow(IdentifiableUserContent(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct User: Identifiable {
    let id: UUID = UUID()
    let name: String
}

fileprivate struct IdentifiableStringContent: View {
    
    @State var names = ["Paul", "Laura", "Tom"]
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(names, id: \.self) {
                name in Text(name)
            }
            Button {
                names.append("NewName")
            } label: {
                Text("Add new name")
            }
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

fileprivate struct IdentifiableUserContent: View {
    
    @State var users = [
        User(name: "Paul"),
        User(name: "Laura"),
        User(name: "Tom")
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(users) {
                user in Text(user.name)
            }
            Button {
                users.append(User(name: "NewName"))
            } label: {
                Text("Add new name")
            }
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}
