/*
 Em Swift, closures são blocos de código auto-contidos que podem ser:
    - Atribuídos a variáveis ou constantes;
    - Passados como parâmetros para funções;
    - Devolvidos como resultado de funções.
 Elas funcionam de maneira semelhante às lambdas de Python ou aos anonymous functions de JavaScript,
 mas oferecem sintaxe e recursos poderosos, como captura de valores.
 Dicas e boas práticas:
    1. Prefira trailing closures quando tiver código mais longo dentro da closure.
    2. Use parâmetros abreviados ($0, $1) em closures curtas; declare nomes explícitos em closures complexas para clareza.
    3. Evite lógica pesada dentro de closures — extraia em funções nomeadas se ficar extenso.
    4. Atenção à captura de valores: para closures que vão viver além do escopo atual (por exemplo, stored properties), considere [weak self] ou [unowned self] para evitar ciclos de referência.
*/

import AppKit
import ArgumentParser
import Foundation

struct ClosuresCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "closures",
        abstract: "Tutorial sobre closures em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Sintaxe Básica:")
        SintaxeBasica.run()
        print("→ Closures como parâmetros de funções:")
        ClosuresComoParametrosDeFuncoes.run()
        print("→ Trailing closures & shorthand argument names:")
        TrailingClosuresEShorthandArguments.run()
        print("→ Aplicação em coleções: map, filter, reduce:")
        AplicacoesEmColecoes.run()
        print("→ Retornando closures e captura de valores:")
        RetornandoClosuresECapturaDeValores.run()
    }
}

/// Sintaxe básica
struct SintaxeBasica {
    static func run() {
        // { (parâmetros) -> TipoRetorno in corpo-da-closure }
        let closureExemplo: (Int, Int) -> Int = { (a: Int, b: Int) -> Int in
            return a + b
        }
        print(closureExemplo(2, 3))   // 5
    }
}

// Podemos criar funções que recebem closures para executar diferentes operações:
func calculator(_ n1: Int, _ n2: Int, operation: (Int, Int) -> Int) -> Int {
    operation(n1, n2)
}

/// Closures como parâmetros de funções
struct ClosuresComoParametrosDeFuncoes {
    static func run() {
        // Funções auxiliares
        func add(_ a: Int, _ b: Int) -> Int { a + b }
        func sub(_ a: Int, _ b: Int) -> Int { b - a }
        func mul(_ a: Int, _ b: Int) -> Int { a * b }

        // Uso com funções nomeadas
        print(calculator(2, 3, operation: add))      // 5
        print(calculator(2, 3, operation: mul))      // 6

        // Uso com closure inline
        print(calculator(2, 3, operation: { (a: Int, b: Int) -> Int in
            return b - a
        }))  // 1
    }
}

/// Trailing closures & shorthand argument names
struct TrailingClosuresEShorthandArguments {
    static func run() {
        // Quando a closure é o último parâmetro, podemos usar sintaxe de trailing closure e nomes abreviados ($0, $1, …):
        // Trailing closure:
        print(calculator(2, 3) { $1 - $0 })   // 1

        // Sintaxe abreviada em diferentes níveis:
        let subtração: (Int, Int) -> Int = { $1 - $0 }
        print(subtração(10, 4))               // -6
    }
}

/// Aplicação em coleções: map, filter, reduce
struct AplicacoesEmColecoes {
    static func run() {
        // Swift padrão oferece métodos para transformar e filtrar arrays usando closures:
        let números = [6, 2, 3, 9, 4, 1]

        // map: aplica transformação a cada elemento
        let maisUm = números.map { $0 + 1 }
        print(maisUm)     // [7, 3, 4, 10, 5, 2]

        // filter: seleciona elementos que satisfazem condição
        let pares = números.filter { $0 % 2 == 0 }
        print(pares)      // [6, 2, 4]

        // reduce: acumula valores em um único resultado
        let somaTotal = números.reduce(0) { acum, item in
            acum + item
        }
        print(somaTotal) // 25
    }
}

/// Retornando closures e captura de valores
struct RetornandoClosuresECapturaDeValores {
    static func run() {
        // Closures podem capturar e manter referências de variáveis externas:
        func makeIncrementer(by amount: Int) -> () -> Int {
            var total = 0
            return {
                total += amount
                return total
            }
        }

        let incByTwo = makeIncrementer(by: 2)
        print(incByTwo())   // 2
        print(incByTwo())   // 4
        print(incByTwo())   // 6
        print(incByTwo())   // 8
        // Aqui, a closure “lembra” da variável total mesmo após o fim da função.
    }
}
