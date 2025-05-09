import SwiftUI

let args = CommandLine.arguments
print("Argumentos: \(args)")

if Apps.SWIFT_UI_ENABLED || args.contains("--ui") {
    print("Vamos iniciar a criação da janela SwiftUI")
    let app = NSApplication.shared

    Apps.run(app)

    print("Tudo feito, finalizando.")
    exit(0)
} else {
    Apps.run()
    exit(0)
}
