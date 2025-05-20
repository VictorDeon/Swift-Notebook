import SwiftUI
import ArgumentParser

struct TextCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "texts",
        abstract: "Textos com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            
            TerminalApp.showWindow(TextContent(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

struct TextContent: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Hello World")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(
                "Um texto of woefow foweof weoufwoe fowefowefou" +
                " wehofweo ufnuwenf weunfowe nfwen ucn wecnuwencwe" +
                " ncwncin w")
                .font(.system(size: 12))
                // Alinha o texto no centro, esquerda (leading) ou direira (trailing)
                .multilineTextAlignment(.center)
                // Da um espaçamento entre linhas
                .lineSpacing(3)
            
            Spacer()
            
            Text(
                "Outro texto of woefow foweof weoufwoe fowefowefou" +
                " wehofweo ufnuwenf weunfowe nfwen ucn wecnuwencwe" +
                " ncwncin w")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                // Se passar de uma linha insira ...
                .lineLimit(1)
                .padding(.horizontal, 20)
            
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}
