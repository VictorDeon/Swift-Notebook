// Arrays sao dados armazenados em um vetor ou matriz multidimensional
// Arrays podem ter tipos diferentes dentro dele se a tipagem for [Any]

import AppKit
import ArgumentParser

struct ArrayCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "array",
        abstract: "Tutorial sobre arrays em swift"
    )

    @OptionGroup var common: CommonOptions
    
    @Option(
        name: .long,  // array
        parsing: .upToNextOption,
        help: "Insira um array de inteiros",
        transform: { str in
          guard let i = Int(str) else {
            throw ValidationError("‘\(str)’ não é um inteiro válido")
          }
          return i
        }
    )
    var array: [Int] = [1, 2, 3, 4, 5]

    func run() throws {
        arrayRunner(array: array)
    }
}

func arrayRunner(array: [Int]) {
    // [value1, value2, ...]
    let array1: [String] = ["Fulano 01", "Fulano 02", "Fulano 03"]
    print(array1) // ["Fulano 01", "Fulano 02", "Fulano 03"]
    let array2: [Int] = array
    print(array2) // [1, 2, 3, 4, 5]
    
    // Acessando os dados de uma array
    print(array1[0])    // Fulano 01
    print(array1[1])    // Fulano 02
    print(array2[4])    // 5
    
    // array bidimensional
    let matriz: [[Int]] = [[1, 2, 3], [5, 2], [2, 3, 4]]
    print(matriz)  // [[1, 2, 3], [5, 2], [2, 3, 4]]
    
    // Acessando os dados de uma matriz
    print(matriz[0])        // [1, 2, 3]
    print(matriz[0][0])     // 1
    print(matriz[1])        // [5, 2]
    print(matriz[1][0])     // 5
    
    // Podemos ter matrizes com N dimensoes
    let m: [[[Int]]] = [[[1, 2], [3, 4]], [[5, 6], [7]]]
    print(m[1][0][1])  // 6
}

