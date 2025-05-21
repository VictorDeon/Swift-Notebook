// Funções seguem a seguinte sintaxe: func MyFunc(external internal: type, ...) -> returnType { ...code }
// Programação funcional é um paradigma de programação que usa funções puras, ou seja, funções que não dependem
// de variaveis externas e não as modifica. Ele sempre retorna o mesmo resultado para as mesmas entradas.
// Impura: func sum(n1: Int, n2: Int) -> Void { result = n1 + n2 }
// Pura: func sum(n1: Int, n2: Int) -> Int { return n1 + n2 }
// Para usar programação funcional use e abuse de Higher Order Functions como .filter, .map, .reduce e etc.

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
        printHello() // Hello World!
        getHelloWorldFunction()() // Hello World!

        // Funções podem ser armazenadas em variaveis
        let sumCopy = sum2
        print(sumCopy(value1, value2)) // 3
        print(mathCalculator(value1, value2, operation: sum1)) // 3
        
        // Funções podem ser armazenadas em data structure
        let operations = [sum1, sum2, sum3, sum4]
        print(operations[0](value1, value2)) // 3
        
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

// Função que recebe outra função como parâmetro
func mathCalculator(_ n1: Int, _ n2: Int, operation: (Int, Int) -> Int) -> Int {
    operation(n1, n2)
}

// Funções podem ser retornada de outras funções.
func getHelloWorldFunction() -> () -> Void {
    return printHello
}

