import SwiftUI
import ArgumentParser

struct ShapeCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "shape",
        abstract: "Shapes com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(ShapeContentView(), title: "Shape")
            app.run()

            print("Finalizado!")
        }
    }
}

struct ShapeContentView: View {
    var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(.blue)
                .stroke(.yellow, lineWidth: 5) // bordas
                .frame(width: 250, height: 100)

            RoundedRectangle(cornerRadius: 10)
                .fill(.red)
                .frame(width: 250, height: 100)

            /// E o mesmo que o RoundedRectangle mas você pode definir arrendondamento em cada borda separadamente.
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomTrailing: 10))
                .fill(.purple)
                .frame(width: 250, height: 100)

            Capsule()
                .fill(.green)
                .frame(width: 250, height: 100)

            Ellipse()
                .fill(.orange)
                .frame(width: 250, height: 100)

            Circle()
                .fill(.pink)
                .frame(width: 100, height: 100)

        }.padding(10)
    }
}

