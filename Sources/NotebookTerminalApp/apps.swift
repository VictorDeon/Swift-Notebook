import ArgumentParser
import SwiftUI

class HostingWindowController<V: View>: NSWindowController, NSWindowDelegate {
    // Cria a janela SwiftUI
    init(rootView: V, title: String) {
        let win = NSWindow(
          contentRect: NSRect(x: 0, y: 0, width: 300, height: 100),
          styleMask: [.titled, .closable, .resizable],
          backing: .buffered,
          defer: false
        )
        win.title = title
        win.level = .floating
        win.collectionBehavior.insert(.canJoinAllSpaces)
        win.center()

        // configuro o contentView e o delegate
        win.contentView = NSHostingView(rootView: rootView)
        super.init(window: win)
        win.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // Quando a janela fecha, paramos o run loop
    func windowWillClose(_ notification: Notification) {
        NSApp.stop(nil)
    }
}

@main
struct TerminalApp: AsyncParsableCommand {
    @MainActor static var windowControllers: [Any] = []

    static let configuration = CommandConfiguration(
        abstract: "Executa exemplos Swift",
        discussion: """
            Exemplos disponíveis:
            basic: array, conditionals, constants, dictionary, enums, loops, scope, types
            intermediary: exceptions, functions, optionals, randoms
            advanced: casting, closures, extensions, oo, protocols
            designPatterns: delegate
            library: timer, thirdPartyLibrary
            ui: swiftUIHelloWold
        """
    )
    
    @Argument(help: "Aplicação que será executada (ex: loops, array, hello_world).")
    var executableApp: String
    
    @Flag(name: .shortAndLong, help: "Executar em modo SwiftUI.")
    var ui: Bool = false
    
    // Executa as ferramentas na thread principal MainActor
    mutating func run() async throws -> Void {
        let args = CommandLine.arguments
        print("Argumentos: \(args[1...])")
        await MainActor.run {
            if self.ui {
                let app = NSApplication.shared
                guard let runnersUI = TerminalApp.runnersUI[executableApp] else {
                    print("🚫 Aplicação de UI desconhecida: \(executableApp)")
                    return
                }
                
                runnersUI(app)
            } else {
                guard let runner = TerminalApp.runners[executableApp] else {
                    print("🚫 Aplicação desconhecida: \(executableApp)")
                    return
                }
                runner()
            }
        }
    }
    
    @MainActor static let runners: [String: () -> Void] = [
        "array": arrayRunner,
        "conditionals": conditionalRunner,
        "constants": constantsRunner,
        "dictionary": dictionaryRunner,
        "enums": enumRunner,
        "loops": loopRunner,
        "scope": scopeRunner,
        "types": typeRunner,
        "exceptions": extensionRunner,
        "functions": functionRunner,
        "optionals": optionalRunner,
        "randoms": randomRunner,
        "casting": castingRunner,
        "closures": closureRunner,
        "extensions": extensionRunner,
        "oo": objectOrientationRunner,
        "protocols": protocolRunner,
        "delegate": delegateRunner,
        "timer": timerRunnerAsync,
        "thirdPartyLibrary": thirdPartyLibraryRunner
    ]
    
    @MainActor static let runnersUI: [String: @MainActor (_ app: NSApplication) -> Void] = [
        "swiftUIHelloWorld": swiftUIHelloWorldRunner
    ]
    
    // Mostra a janela do SwiftUI
    @MainActor static func showWindow<V: View>(_ view: V, title: String) {
        let controller = HostingWindowController(rootView: view, title: title)
        windowControllers.append(controller)
        controller.showWindow(nil)
    }
}
