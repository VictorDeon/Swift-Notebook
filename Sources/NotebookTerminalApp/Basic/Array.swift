// Em Swift, um Array é uma coleção indexada de elementos de um mesmo tipo.
// Arrays em Swift são mutáveis se declarados com var e imutáveis se declarados com let.

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
          guard let intValue = Int(str) else {
            throw ValidationError("‘\(str)’ não é um inteiro válido")
          }
          return intValue
        }
    )
    var array: [Int] = [1, 2, 3, 4, 5]

    func run() throws {
        ArrayRunner(array: array).execute()
    }
}

struct SintaxeDeArray {
    static func run(array: [Int]) {
        let nomes: [String] = ["Alice", "Bob", "Carol"]
        print(nomes) // ["Alice", "Bob", "Carol"]
        let numeros = array
        print(numeros) // [1, 2, 3, 4, 5]
    }
}

struct PropriedadesBasicas {
    static func run() {
        let nomes: [String] = ["Alice", "Bob", "Carol"]

        // Número de elementos
        print(nomes.count)          // 3
        // true se vazio, caso contrário false
        print(nomes.isEmpty)        // false
        // Primeiro e ultimo elemento (opcional)
        print(nomes.first!)         // "Alice"
        print(nomes.last!)          // "Carol"
        // Índices inicial/final
        print(nomes.startIndex)     // 0
        print(nomes.endIndex)       // 3 (index final + 1)
        // Intervalo de índices válidos (usado em for)
        print(nomes.indices)        // 0..<3
        // Capacidade interna antes de realocar
        print(nomes.capacity)       // 3
    }
}

struct AcessandoElementos {
    static func run() {
        let frutas = ["🍎", "🍌", "🍇", "🍊"]
        print(frutas[0])                    // 🍎
        print(frutas[frutas.startIndex])    // 🍎
        print(frutas[1])                    // 🍌
        print(frutas[frutas.count - 1])     // 🍊
        print(frutas[frutas.endIndex - 1])  // 🍊
    }
}

struct Mutacoes {
    static func run() {
        var letras = ["a", "b", "c"]

        // Adicionar
        letras.append("d")
        print(letras)                   // ["a","b","c","d"]
        letras += ["e", "f"]
        print(letras)                   // ["a","b","c","d","e","f"]

        // Inserir em posição
        letras.insert("z", at: 0)
        print(letras)                   // ["z","a","b","c","d","e","f"]

        // Remover
        _ = letras.removeLast()                 // retorna "f"
        print(letras)                           // ["z","a","b","c","d","e"]
        _ = letras.removeFirst()                // retorna "z"
        print(letras)                           // ["a","b","c","d","e"]
        _ = letras.remove(at: 2)                // remove "b"
        print(letras)                           // ["a","b","d","e"]
        letras.removeAll(where: { $0 == "d" })  // remove todos os "d"
        print(letras)                           // ["a","b","e"]

        // Substituir
        letras[1] = "x"             // troca no índice 1
        print(letras)               // ["a","x","e"]
        letras[0...1] = ["u", "v"]   // substitui intervalo
        print(letras)               // ["u","v","e"]
    }
}

struct TransformacoesFuncionais {
    static func run() {
        let nums = [1, 2, 3, 4, 5]

        // Transforma cada elemento (Dobrar valores)
        let dobrados = nums.map { $0 * 2 }
        print(dobrados)                         // [2, 4, 6, 8, 10]

        // Filtrar pares
        let pares = nums.filter { $0.isMultiple(of: 2) }
        print(pares)                            // [2, 4]

        // Soma de todos
        let soma = nums.reduce(0) { anterior, valor in anterior + valor }
        print(soma)                             // 15

        // Mapeia descartando nil (Converter strings em números)
        let raw = ["10", "dois", "30"]
        let inteiros = raw.compactMap { Int($0) }
        print(inteiros)                         // [10, 30]

        // Achata coleções de coleções (Achatar matriz)
        let matriz = [[1, 2], [3, 4], [5]]
        let plano = matriz.flatMap { $0 }
        print(plano)                            // [1,2,3,4,5]

        // Itera sem retornar array
        nums.forEach { valor in
            print(valor)
        }
        // 1
        // 2
        // 3
        // 4
        // 5

        var unsortedValues = [3, 1, 2]
        // Ordena uma copia da variavel e retorna ela
        let orderedValues = [3, 1, 2].sorted()
        print(unsortedValues)                   // [3, 1, 2]
        print(orderedValues)                    // [1, 2, 3]
        // Ordena valores na propria variavel
        unsortedValues.sort()
        print(unsortedValues)                   // [1, 2, 3]
    }
}

struct BuscaEConsulta {
    static func run() {
        let cores = ["vermelho", "verde", "azul", "amarelo"]

        let hasGreen = cores.contains("verde")
        print(hasGreen)                             // true
        let blueIndex = cores.firstIndex(of: "azul")
        print(blueIndex!)                           // 2
        let yellowIndex = cores.firstIndex(where: { $0.hasPrefix("am") })
        print(yellowIndex!)                         // 3
        let lastGreenIndex = cores.lastIndex(of: "verde")
        print(lastGreenIndex!)                      // 1
        let allSatisfyCondition = cores.allSatisfy { $0.count > 3 }
        print(allSatisfyCondition)                  // true
        let getRandomColor = cores.randomElement()
        print(getRandomColor!)                      // azul ou vermelho ou amarelo ou verde
    }
}

struct OrdenacaoEmbaralhamento {
    static func run() {
        var numeros = [3, 1, 4, 2]

        // Ordenado sem alterar original
        let ordenado = numeros.sorted()
        print(ordenado)                     // [1,2,3,4]

        // Ordena in-place
        numeros.sort()
        print(numeros)                      // [1,2,3,4]

        // Reverso
        let invertido = Array(numeros.reversed())
        print(invertido)                    // [4,3,2,1]

        // Shuffle (iOS 13+)
        numeros.shuffle()
        print(numeros)                      // [2,4,1,3] ou [1,2,4,3] ou ...
    }
}

struct FatiamentoFragmentos {
    static func run() {
        let letras = ["a", "b", "c", "d", "e"]

        // Prefixos e Sufixos
        print(letras.prefix(3))     // ["a","b","c"]
        print(letras.suffix(2))     // ["d","e"]

        // Drop (descarta)
        print(letras.dropFirst(2))              // ["c","d","e"]
        print(letras.dropLast())                // ["a","b","c","d"]
        print(letras.dropFirst(2).prefix(2))    // ["c", "d"]

        // Split por separador
        let frase = ["Olá", "", "Mundo", "Swift", "", "!"]
        let partes = frase.split(separator: "")
        print(partes)   // [ArraySlice(["Olá"]), ArraySlice(["Mundo", "Swift"]), ArraySlice(["!"])]
    }
}

struct CombinacaoEnumeracao {
    static func run() {
        let array1 = [1, 2, 3]
        let array2 = ["x", "y", "z", "k"]

        // Enumerar com índice
        for (value1, value2) in array2.enumerated() {
            print(value1, value2)
        }
        // 0 x
        // 1 y
        // 2 z
        // 3 k

        // Zip de duas coleções
        for (value1, value2) in zip(array1, array2) {
            print("\(value1): \(value2)")
        }
        // 1: x
        // 2: y
        // 3: z

        // Joined (apenas se elementos forem Sequence)
        let palavras = ["um", "dois", "três"]
        let join = palavras.joined(separator: " | ")
        print(join)     // um | dois | três
    }
}

struct ArraysMultidimensionais {
    static func run() {
        let matriz2D: [[Int]] = [[1, 2, 3], [4, 5, 6]]
        print(matriz2D[1][2])   // 6

        // Achatar 2D para 1D
        let plano2D = matriz2D.flatMap { $0 }
        print(plano2D)          // [1,2,3,4,5,6]
    }
}

struct OutrasUtilidades {
    static func run() {
        // Trocar dois elementos
        var mix = [10, 20, 30]
        mix.swapAt(0, 2)
        print(mix)          // [30,20,10]

        // Remover duplicados (usando Set)
        let repetidos = [1, 2, 2, 3, 3, 3]
        let unicos = Array(Set(repetidos))  // ordem não garantida
        print(unicos)   // [1,2,3]

        // Partition: agrupa conforme predicado (iOS 14+)
        var part = [1, 2, 3, 4]
        let pivot = part.partition(by: { $0.isMultiple(of: 2) })
        print("Pivo: \(pivot)")     // 2
        print(part[0..<pivot])      // impares [1, 3]
        print(part[pivot...])       // pares [2, 4]

        // Pop last (retira e retorna opcional)
        var pilha = [1, 2, 3]
        let top = pilha.popLast()
        print(top!)     // 3
        print(pilha)    // [1,2]
    }
}

struct ArrayRunner {
    var array: [Int] = []

    func execute() {
        print("→ Sintaxe Basica de Arrays:")
        SintaxeDeArray.run(array: array)
        print("→ Propriedades Basica de Arrays:")
        PropriedadesBasicas.run()
        print("→ Acessando elementos do Arrays:")
        AcessandoElementos.run()
        print("→ Inserir, Remover e Substituir elementos do Arrays:")
        Mutacoes.run()
        print("→ Transformações funcionais:")
        TransformacoesFuncionais.run()
        print("→ Busca e Consulta em Arrays:")
        BuscaEConsulta.run()
        print("→ Ordenação e Embaralhamento em Arrays:")
        OrdenacaoEmbaralhamento.run()
        print("→ Fatiamento e Fragmentação em Arrays:")
        FatiamentoFragmentos.run()
        print("→ Combinação e Enumeração em Arrays:")
        CombinacaoEnumeracao.run()
        print("→ Arrays Multidimensionais:")
        ArraysMultidimensionais.run()
        print("→ Outras Utilidades:")
        OutrasUtilidades.run()
    }
}
