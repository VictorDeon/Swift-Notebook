/*
 Em Swift, Extensions permitem adicionar novas funcionalidades a tipos já existentes —
 classes, structs, enums, protocolos ou tipos primitivos — sem precisar modificar o código
 original. Com elas você pode:
    1. Permitem adicionar métodos, propriedades computadas e conformidade a protocolos.
    2. Não podem adicionar stored properties.
    3. São excelentes para organizar funcionalidades relacionadas sem alterar o tipo original.
    4. Organizar melhor seu código em módulos.
 Boa prática:
    1. Documente cada método/propriedade na extension com comentários ///.
    2. Agrupe extensions por responsabilidade (ex.: extensão de formatação, de cálculo, de API, etc.).
*/

import Foundation
import AppKit
import ArgumentParser

struct ExtensionCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "extensions",
        abstract: "Tutorial sobre extensions em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let runner = ExtensionsRunner()
        runner.execute()
    }
}

/// Adiciona função de arredondamento customizado a Double
extension Double {
    /// Retorna o valor arredondado para 'places' casas decimais
    ///
    /// - Parameter places: número de casas decimais desejadas
    /// - Returns: valor arredondado
    func rounded(to places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        // Multiplica, arredonda e depois divide de volta
        return (self * factor).rounded() / factor
    }
}

struct ExtensionsRunner {
    func execute() {
        let original: Double = 3.14159

        // 1) Arredondamento padrão (sem extension)
        print("Rounded padrão:", original.rounded())        // → 3.0

        // 2) Arredondamento customizado via extension
        print("1 casa decimal:", original.rounded(to: 1))   // → 3.1
        print("2 casas decimais:", original.rounded(to: 2)) // → 3.14
        print("3 casas decimais:", original.rounded(to: 3)) // → 3.142
        print("4 casas decimais:", original.rounded(to: 4)) // → 3.1416
    }
}
