import SwiftUI
import ArgumentParser
import VKSwiftUI

struct BindingCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "binding",
        abstract: "Binding com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalSwiftUI.showWindow(BindingContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct BindingContentView: View {
    
    @State private var selectedColor: Color = .clear
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            ColorContentView(selectedColor: $selectedColor)
            Rectangle()
                .fill(selectedColor)
                .frame(width: 100, height: 100)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

fileprivate struct ColorContentView: View {
    
    @Binding var selectedColor: Color
    let colors: [Color] = [.red, .purple, .green, .yellow, .blue]
    
    // Não é obrigatorio criar, mas é bom saber
    init(selectedColor: Binding<Color>) {
        // Observe: usamos o under-score para atribuir ao wrapper
        self._selectedColor = selectedColor
    }
    
    var body: some View {
        let _ = Self._printChanges()
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: selectedColor == color ? "record.circle.fill" : "circle.fill")
                    .foregroundStyle(color)
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

