import SwiftUI
import ArgumentParser

/// Download do app com todos os symbols: https://developer.apple.com/sf-symbols/
struct SFSymbolCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sfsymbols",
        abstract: "SF Symbols com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            
            TerminalApp.showWindow(SFSymbolContent(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

struct SFSymbolContent: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.circle")
                .font(.system(size: 50))
                .fontWeight(.medium)
                .foregroundStyle(Color.white)
            
            Image(systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
                .font(.system(size: 50))
                // Modo de renderização do icone
                // .monochrome é tudo em uma unica cor
                // .hierarchical tem corer em forma de hierarquia background mais claro que o foreground.
                // .palette você pode definir multiplas cores do foreground até o background
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.red, Color.white.opacity(0.6))
            
            /// .multicolor:  Muito usado em icones que representa progresso.
            Image(systemName: "wave.3.right", variableValue: 0.5)
                .font(.system(size: 50))
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(Color.gray)
            
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}
