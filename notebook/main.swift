import SwiftUI

let SWIFT_UI_ENABLED: Bool = true

if SWIFT_UI_ENABLED {
    print("Vamos iniciar a criação da janela SwiftUI")
    let app = NSApplication.shared

    Apps.ui.hello_world(app)

    print("Tudo feito, finalizando.")
    exit(0)
} else {
    await Apps.basic.array()
}
