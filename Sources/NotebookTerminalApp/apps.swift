import ArgumentParser
import SwiftUI

class HostingWindowController<V: View>: NSWindowController, NSWindowDelegate {
    // Cria a janela SwiftUI
    init(rootView: V, title: String, x: Int, y: Int, width: Int, height: Int) {
        let win = NSWindow(
            contentRect: NSRect(x: x, y: y, width: width, height: height),
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

struct CommonOptions: ParsableArguments {
    @Option(
        name: [.short, .customLong("log")],  // -l ou --log
        help: "Nível de logging (debug, info, warning, error)",
        transform: { log in
            setenv("LOG_LEVEL", log, 1)
            if let valor = ProcessInfo.processInfo.environment["LOG_LEVEL"] {
                print("LOG_LEVEL = \(valor)")
                return valor
            }
            return log
          }
    )
    var logLevel: String = "info"

    @Option(
        name: [.short, .customLong("plist")],  // -p ou --plist
        help: "Caminho para o arquivo .plist",
        completion: .file(extensions: [".plist"])
    )
    var plistPath: String?
    
    @Flag(
        name: .shortAndLong,  // -s ou --simulate
        help: "Só mostra o que seria feito, sem executar"
    )
    var simulate: Bool = false
}

@main
struct TerminalApp: AsyncParsableCommand {
    @MainActor static var windowControllers: [Any] = []
    
    static let configuration = CommandConfiguration(
        commandName: "NotebookTerminalApp",
        abstract: "Ferramenta Toolbox: escolhe um executável e passa os parâmetros certos",
        version: "0.1.0",
        subcommands: [
            // Basic
            ArrayCommands.self,
            ConditionalCommands.self,
            ConstantCommands.self,
            DictionaryCommands.self,
            EnumCommands.self,
            LoopCommands.self,
            ScopeCommands.self,
            TypeCommands.self,
            // Intermediary
            ExceptionCommands.self,
            FunctionCommands.self,
            OptionalCommands.self,
            RandomCommands.self,
            LoggingCommands.self,
            // Advanced
            CastingCommands.self,
            ClosuresCommands.self,
            ExtensionCommands.self,
            OOCommands.self,
            ComputedAttributesCommands.self,
            CicloDeReferenciaCommands.self,
            AssociationCommands.self,
            // Design Patterns
            DelegateCommands.self,
            SingletonCommands.self,
            // Libraries
            RequestCommands.self,
            TimeCommands.self,
            // Databases
            UserDefaultCommands.self,
            NSCoderCommands.self,
            SQLiteCommands.self,
            RealmCommands.self,
            KeyChainCommands.self,
            // Algoritmos
            PaintingBucketsCommands.self,
            // SwiftUI
            SwiftUIHelloWorldCommands.self,
        ]
    )

    // Mostra a janela do SwiftUI
    @MainActor static func showWindow<V: View>(_ view: V, title: String, x: Int = 0, y: Int = 0, width: Int = 300, height: Int = 100) {
        let controller = HostingWindowController(rootView: view, title: title, x: x, y: y, width: width, height: height)
        windowControllers.append(controller)
        controller.showWindow(nil)
    }
}
