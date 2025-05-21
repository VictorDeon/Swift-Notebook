// Vamos criar uma constantes com o struct

import AppKit
import ArgumentParser

struct InputCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "input",
        abstract: "Tutorial sobre inputs em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("Digite o caminho do arquivo:")
        guard let input = readLine(), !input.isEmpty else {
            fatalError("Caminho inválido para o arquivo.")
        }

        print("Caminho do arquivo: \(input)")
    }
}
