// No Swift, escopo determina onde uma variável ou constante é visível e acessível.
// Variáveis declaradas dentro de um bloco ({ … }), função ou closure só podem ser usadas naquele contexto.

import AppKit
import ArgumentParser

struct ScopeCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scope",
        abstract: "Tutorial sobre escopo em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Escopo global vs. escopo local:")
        EscopoGlobalVsLocal.run()
        print("→ Funções aninhadas e escopo de bloco:")
        FuncoesAninhadasEscopoDeBloco.run()
        print("→ let vs. var no escopo:")
        LetVsVarNoEscopo.run()
        print("→ Shadowing (sombreamento):")
        Shadowing.run()
        print("→ Escopo de closures e captura de variáveis:")
        EscopoDeClosure.run()
    }
}

/// Global: declarado fora de qualquer função ou tipo, visível em todo o arquivo (e em módulos importados, se public).
/// Local: dentro de func, if, for, etc. Morre quando o bloco termina.
struct EscopoGlobalVsLocal {
    static func run() {
        // 1) Global (arquivo inteiro) se esse codigo estivesse em um arquivo separado
        let globalValue = "👋 Olá, Swift!"

        func showGlobal() {
            print(globalValue) // ok -> 👋 Olá, Swift!
        }
        showGlobal()

        // 2) Local (dentro de função/bloco)
        func exampleLocal() {
            let localValue = 42
            print(localValue)   // ok -> 42
        }
        // print(localValue)    // ❌ Erro: 'localValue' não existe aqui
        exampleLocal()
    }
}

/// Funçoes aninhadas e escopo de bloco
struct FuncoesAninhadasEscopoDeBloco {
    static func run() {
        func outerFunction() {
            var count = 0

            func innerFunction() {
                count += 1        // inner “vê” e modifica 'count'
                print("Count = \(count)")
            }

            innerFunction()      // Count = 1
            innerFunction()      // Count = 2
        }

        outerFunction()

        // Cada bloco (if, while, { … }) também cria um novo escopo:
        let value = 10
        if value > 5 {
            let value = 100           // sombreia (shadowing) o 'x' externo
            print(value)              // 100 (dentro do bloco)
        }
        print(value)                  // 10  (fora do bloco)
    }
}

/// let: cria constantes imutáveis — não podem mudar de valor.
/// var: cria variáveis mutáveis — podem ser alteradas.
struct LetVsVarNoEscopo {
    static func run() {
        let pii = 3.14
        print(pii)               // 3.14
        // pi = 3.1415          // ❌ Erro: não pode reatribuir

        var counter = 0
        counter += 1            // ok
        print(counter)          // 1
    }
}

/// Declarar uma nova variável com mesmo nome dentro de um escopo interno “esconde” a externa
/// Use shadowing com cuidado para não confundir quem lê.
struct Shadowing {
    static func run() {
        let message = "Olá"
        func greet() {
            let message = "Oi, mundo!"
            print(message)         // "Oi, mundo!"
        }
        greet()
        print(message)             // "Olá"
    }
}

/// Escopo de closures e captura de variáveis
/// Closures herdam o escopo léxico onde foram criadas e capturam referências a variáveis externas
/// total vive enquanto a closure existir, mesmo após makeIncrementer terminar.
struct EscopoDeClosure {
    static func run() {
        func makeIncrementer(by amount: Int) -> () -> Int {
            var total = 0
            let incrementer: () -> Int = {
                total += amount
                return total
            }
            return incrementer
        }

        let incByTen = makeIncrementer(by: 10)
        print(incByTen())  // 10
        print(incByTen())  // 20
    }
}
