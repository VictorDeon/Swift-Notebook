import SwiftUI
import AppKit

// faz o run() retornar
class WindowCloseDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.stop(nil)
    }
}

// Helper para criar e apresentar uma janela SwiftUI
func showWindow<V: View>(_ view: V, title: String) {
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 300, height: 100),
        styleMask: [.titled, .closable, .resizable],
        backing: .buffered,
        defer: false
    )
    // mantém sempre no topo
    window.level = .floating
    // aparece em todas as Spaces
    window.collectionBehavior.insert(.canJoinAllSpaces)
    window.center()
    window.title = title
    let delegate = WindowCloseDelegate()
    window.delegate = delegate
    window.contentView = NSHostingView(rootView: view)
    window.makeKeyAndOrderFront(nil)
}
