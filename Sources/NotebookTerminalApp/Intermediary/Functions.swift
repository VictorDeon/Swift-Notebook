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
        name: .long,  // numerador
        help: "valor 1"
    )
    var n1: Int = 1
    
    @Option(
        name: .long,  // denominador
        help: "valor 2"
    )
    var n2: Int = 2

    func run() throws {
        functionRunner(n1, n2)
    }
}

// Parametros nomeados iguais Externamente e Internamente
func sum1(n1: Int, n2: Int) -> Int {
    return n1 + n2
}

// Parametros nao nomeados
func sum2(_ n1: Int, _ n2: Int) -> Int {
    return n1 + n2
}

// Parametros nomeados diferentes Externamente e Internamente
func sum3(n1 number1: Int, n2 number2: Int) -> Int {
    return number1 + number2
}

// Parametros nomeados e Nao nomeados na mesma função
func sum4(_ n1: Int, n2: Int) -> Int {
    return n1 + n2
}

// Função sem retorno e sem parâmetros
func printHello() -> Void {
    print("Hello World!")
}


func functionRunner(_ n1: Int, _ n2: Int) {
    print(sum1(n1: n1, n2: n2))   // 3
    print(sum2(n1, n2))           // 3
    print(sum3(n1: n1, n2: n2))   // 3
    print(sum4(n1, n2: n2))       // 3
    printHello()
}
