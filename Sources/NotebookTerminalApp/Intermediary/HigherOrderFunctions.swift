import AppKit
import ArgumentParser
import Foundation

struct HigherOrderFunctionsCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "higher-order-functions",
        abstract: "Tutorial sobre Higher Order Functions em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("1. Transformação de elementos")
        print("1.1 map:")
        // Aplica uma função a cada elemento de uma sequência e retorna um array com os resultados.
        let nums = [1, 2, 3, 4]
        let double = nums.map { $0 * 2 }
        print(double) // [2, 4, 6, 8]
        
        print("1.2 compactMap:")
        // Semelhante ao map, mas descarta resultados nil, portanto o retorno é não-optinal.
        let strings = ["1", "foo", "3", "bar"]
        let ints = strings.compactMap { Int($0) }
        print(ints) // [1, 3]
        
        print("1.3 flatMap:")
        // “Achata” uma sequência de sequências em um único nível. Em Swift 4.1+, flatMap aplicado a
        // transformações que retornam arrays é equivalente a map + joined().
        let arrayOfArrays = [[1,2], [3,4], [5]]
        let flat = arrayOfArrays.flatMap { $0 }
        print(flat) // [1, 2, 3, 4, 5]
        
        print("2. Filtragem de elementos")
        print("2.1 filter:")
        // Retorna apenas os elementos que satisfazem o predicado.
        let nums2 = [10, 15, 20, 25]
        let evens = nums2.filter { $0 % 2 == 0 }
        print(evens) // [10, 20]
        
        print("2.2 drop e prefix:")
        // drop(while:) descarta do início enquanto a condição for verdadeira, depois retorna o resto.
        // prefix(while:) mantém do início enquanto a condição for verdadeira, depois para.
        let nums3 = [1, 2, 3, 0, 4, 5]
        let newDrop = nums3.drop(while: { $0 < 3 })
        print(newDrop) // [3, 0, 4, 5]
        let newPrefix = nums3.prefix(while: { $0 < 3 })
        print(newPrefix) // [1, 2]
        
        print("2.3 split:")
        // Divide em sub-arrays usando um separador.
        let sentence = "one,two,,three"
        let parts = sentence.split(separator: ",", omittingEmptySubsequences: true)
        print(parts) // ["one", "two", "three"]
        
        print("3. Redução e agregação")
        print("3.1 reduce")
        // Acumula todos os elementos em um único valor, começando de um “valor inicial”.
        let nums4 = [1, 2, 3, 4]
        let sum = nums4.reduce(0) { acc, next in acc + next }
        print(sum) // 10
        // Versão mais eficiente quando o acumulador é um objeto mutável (por ex., array ou dicionário).
        let words = ["apple", "banana", "carrot", "avocato"]
        let byFirstLetter = words.reduce(into: [Character: [String]]()) { dict, word in
            let key = word.first!
            dict[key, default: []].append(word)
        }
        print(byFirstLetter) // ["a": ["apple", "avocato"], "b": ["banana"], "c": ["carrot"]]
        
        print("4. Iteração")
        print("4.1 forEach")
        // Executa uma função em cada elemento. Não retorna nada (ao contrário de map).
        let names = ["Alice", "Bob", "Carol"]
        names.forEach { print("Olá, \($0)!") }
        // Olá Alice
        // Olá Bob
        // Olá Carol
        
        print("5. Ordenação e busca")
        print("5.1 sorted")
        // Retorna um array ordenado pelo critério dado.
        let nums5 = [3, 1, 4, 2]
        let asc = nums5.sorted(by: <)
        print(asc) // [1, 2, 3, 4]
        let desc = nums5.sorted(by: >)
        print(desc) // [4, 3, 2, 1]
        
        print("5.2 min / max")
        // Encontra o menor/maior elemento segundo um critério.
        let people = [("Alice", 30), ("Bob", 25), ("Carol", 40), ("Pedro", 26)]
        let youngest = people.min { $0.1 < $1.1 }
        print(youngest!) // ("Bob", 25)
        let oldest = people.max { $0.1 < $1.1 }
        print(oldest!) // ("Carol", 40)
        
        print("5.3 first, contains, allSatisfy")
        // first(where:): primeiro elemento que satisfaz
        // contains(where:): existe algum elemento que satisfaz?
        // allSatisfy(_:): todos satisfazem?
        let nums6 = [10, 15, 20, 25]
        let firsts = nums6.first { $0 % 3 == 0 }
        print(firsts!) // 15?
        let contains = nums6.contains { $0 > 100 }
        print(contains) // false
        let satisfy = nums6.allSatisfy { $0 % 5 == 0 }
        print(satisfy) // true
        
        print("6. Combinação e enumeração")
        print("6.1 enumerated")
        // Retorna pares (índice, elemento).
        let letters = ["a", "b", "c"]
        for (i, letter) in letters.enumerated() {
            print(i, letter)
        }
        // 0 a
        // 1 b
        // 2 c
        
        print("6.2 zip")
        // Combina duas sequências em pares, até o menor comprimento.
        let a = [1, 2, 3]
        let b = ["one", "two", "three", "four"]
        for (n, s) in zip(a, b) {
            print("\(n) is \(s)")
        }
        // 1 is one
        // 2 is two
        // 3 is three
        
        print("7. Operações sobre strings e coleções de coleções")
        print("7.1 joined")
        // “Achata” uma sequência de sequências em uma única sequência — útil para arrays de strings.
        let words1 = [["hi", "there"], ["how", "are", "you"]]
        let sentence1 = words1.joined(separator: [" "])
        print(Array(sentence1).joined(separator: " "))  // "hi there how are you"
        
        print("7.2 Dictionary")
        // Agrupa uma sequência em um dicionário, pela chave retornada.
        let nums7 = [1,2,3,4,5,6]
        let evensAndOdds = Dictionary(grouping: nums7) { $0 % 2 == 0 }
        print(evensAndOdds) // [false: [1,3,5], true: [2,4,6]]
        
        print("8. Lazy Evaluation")
        // Você pode encadear transformações sem gerar arrays intermediários,
        // usando .lazy antes de map, filter, etc.
        let nums10 = Array(1...1_000_000)
        let firstFiveSquares = nums10.lazy
            .map { $0 * $0 }
            .filter { $0 % 2 == 0 }
            .prefix(5)

        print(Array(firstFiveSquares)) // [4, 16, 36, 100]
    }
}

