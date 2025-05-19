import ArgumentParser
import SwiftUI

func readVersion() -> String {
  // Bundle.module só existe em SPM para targets com resources
  guard let url = Bundle.module.url(forResource: "version", withExtension: "txt") else {
    fatalError("version.txt não encontrado no bundle")
  }
  do {
    return try String(contentsOf: url, encoding: .utf8)
  } catch {
    fatalError("Falha ao ler version.txt: \(error)")
  }
}

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
        version: readVersion(),
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
            // Advanced
            CastingCommands.self,
            ClosuresCommands.self,
            ExtensionCommands.self,
            OOCommands.self,
            ComputedAttributesCommands.self,
            CicloDeReferenciaCommands.self,
            AssociationCommands.self,
            SOCommands.self,
            IOCommands.self,
            ConcorrencyCommands.self,
            CriptografyCommands.self,
            LaunchDaemonCommands.self,
            // Design Patterns
            DelegateCommands.self,
            SingletonCommands.self,
            // Libraries
            RequestCommands.self,
            TimeCommands.self,
            LoggingCommands.self,
            DateTimeCommands.self,
            RegexCommands.self,
            // Databases
            UserDefaultCommands.self,
            NSCoderCommands.self,
            SQLiteCommands.self,
            RealmCommands.self,
            KeyChainCommands.self,
            // Algoritmos
            PaintingBucketsCommands.self,
            // SwiftUI
            LayoutCommands.self,
            TextCommands.self,
            SFSymbolCommands.self,
            ImageCommands.self,
            ShapeCommands.self,
            ColorCommands.self,
            ButtonCommands.self
        ]
    )

    // Mostra a janela do SwiftUI
    @MainActor static func showWindow<V: View>(_ view: V, title: String) {
        let controller = HostingWindowController(rootView: view, title: title)
        windowControllers.append(controller)
        controller.showWindow(nil)
    }
}
