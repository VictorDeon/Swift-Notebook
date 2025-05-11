// Closures sao funçoes anonimas, igual ao lambda do python
// Podemos enviar funções como input e receber funçoes como output
// Sintaxe: { (parameters) -> return type in statement }

import AppKit
import ArgumentParser

struct ClosuresCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "closures",
        abstract: "Tutorial sobre closures em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        closureRunner()
    }
}

func calculator(n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(n1, n2)
}

func add(n1: Int, n2: Int) -> Int {
    return n1 + n2
}

func sub(n1: Int, n2: Int) -> Int {
    return n2 - n1
}

func multiply(n1: Int, n2: Int) -> Int {
    return n1 * n2
}

func division(d1: Int, d2: Int) -> Float? {
    if d2 == 0 {
        return nil
    }

    return Float(d1) / Float(d2)
}

func addOne(n1: Int) -> Int {
    return n1 + 1
}

func closureRunner() {
    print(calculator(n1: 2, n2: 3, operation: add)) // 5
    print(calculator(n1: 2, n2: 3, operation: multiply)) // 6
    print(calculator(n1: 2, n2: 3, operation: sub)) // 1
    print(calculator(n1: 2, n2: 3, operation: {(n1: Int, n2: Int) -> Int in return n2 - n1})) // 1
    print(calculator(n1: 2, n2: 3, operation: {(n1, n2) in n2 - n1})) // 1
    print(calculator(n1: 2, n2: 3, operation: {$1 - $0})) // 1
    print(calculator(n1: 2, n2: 3) {$1 - $0})  // 1 Se o closure for o ultimo parametro podemos escrever assim.
    
    // Closure usando arrays
    let array = [6, 2, 3, 9, 4, 1]
    print(array.map(addOne))   // [7, 3, 4, 10, 5, 2]
    print(array.map({$0 + 1})) // [7, 3, 4, 10, 5, 2]
    print(array.map{$0 + 1})   // [7, 3, 4, 10, 5, 2]
    print(array)               // [6, 2, 3, 9, 4, 1]
}
