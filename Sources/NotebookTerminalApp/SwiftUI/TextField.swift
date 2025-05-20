import SwiftUI
import ArgumentParser

struct TextFieldCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "text-field",
        abstract: "Text Field com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(TextFieldContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

struct TextFieldContentView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var biografy: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Username: \(username)")
                Text("Biografy: \(biografy)")
                Spacer()
                TextField("Username", text: $username)
                    .font(.system(size: 15, weight: .semibold))
                    .textContentType(.username)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 10)
                
                SecureField("Password", text: $password)
                    .font(.system(size: 15, weight: .semibold))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 10)
                
                TextEditor(text: $biografy)
                    .foregroundStyle(Color.black)
                    .scrollContentBackground(.hidden)
                    .frame(height: 150)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 10)

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
