// Funções seguem a seguinte sintaxe: func MyFunc(external internal: type, ...) -> returnType { ...code }

import AppKit
import ArgumentParser

struct FunctionCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "functions",
        abstract: "Tutorial sobre funções em swift"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .customLong("n1"),  // numerador
        help: "valor 1"
    )
    var value1: Int = 1

    @Option(
        name: .customLong("n2"),  // denominador
        help: "valor 2"
    )
    var value2: Int = 2

    func run() throws {
        print(sum1(value1: value1, value2: value2))   // 3
        print(sum2(value1, value2))           // 3
        print(sum3(value1: value1, value2: value2))   // 3
        print(sum4(value1, value2: value2))       // 3
        printHello()
    }
}

// Parametros nomeados iguais Externamente e Internamente
func sum1(value1: Int, value2: Int) -> Int {
    return value1 + value2
}

// Parametros nao nomeados
func sum2(_ value1: Int, _ value2: Int) -> Int {
    return value1 + value2
}

// Parametros nomeados diferentes Externamente e Internamente
func sum3(value1 number1: Int, value2 number2: Int) -> Int {
    return number1 + number2
}

// Parametros nomeados e Nao nomeados na mesma função
func sum4(_ value1: Int, value2: Int) -> Int {
    return value1 + value2
}

// Função sem retorno e sem parâmetros
func printHello() {
    print("Hello World!")
}
