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
            InputCommands.self,
            // Intermediary
            ExceptionCommands.self,
            FunctionCommands.self,
            OptionalCommands.self,
            RandomCommands.self,
            HigherOrderFunctionsCommands.self,
            CastingCommands.self,
            ExtensionCommands.self,
            OOCommands.self,
            POPCommands.self,
            // Advanced
            ClosuresCommands.self,
            PropertiesCommands.self,
            CicloDeReferenciaCommands.self,
            AssociationCommands.self,
            SOCommands.self,
            IOCommands.self,
            ConcorrencyCommands.self,
            CriptografyCommands.self,
            LaunchDaemonCommands.self,
            GenericsCommands.self,
            // Design Patterns
            DelegateCommands.self,
            SingletonCommands.self,
            MVVMCommands.self,
            SingleResponsabilityPrincipleCommands.self,
            OpenClosePrincipleCommands.self,
            LiskovSubstitutionPrincipleCommands.self,
            InterfaceSegregationPrincipleCommands.self,
            DependencyInversionPrincipleCommands.self,
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
            ButtonCommands.self,
            StateCommands.self,
            AlertCommands.self,
            IdentifiableCommands.self,
            SheetsAndNavigationCommands.self,
            ListCommands.self,
            GridsCommands.self,
            ViewBuilderCommands.self,
            InputFieldCommands.self,
            BindingCommands.self,
            EnvironmentObjectCommands.self,
            EnvironmentCommands.self
        ]
    )
}
