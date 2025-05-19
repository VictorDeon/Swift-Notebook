// Tipos de dados

import AppKit
import ArgumentParser

struct TypeCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "types",
        abstract: "Tutorial sobre tipos em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ String:")
        StringType.run()
        print("→ Int:")
        IntType.run()
        print("→ Float e Double:")
        FloatType.run()
        print("→ Boolean:")
        BoolType.run()
        print("→ Array:")
        ArrayType.run()
        print("→ Dictionary:")
        DictType.run()
        print("→ Set:")
        SetType.run()
        print("→ Tupla:")
        TupleType.run()
        print("→ Any e AnyObject:")
        AnyType.run()
    }
}

/// Tipo String
struct StringType {
    static func run() {
        let frase = "Olá, Swift é ótimo!"

        // split(separator:)
        let palavras = frase.split(separator: " ")
        print(palavras)
        // → ["Olá,", "Swift", "é", "ótimo!"]

        // uppercased() / lowercased()
        print(frase.uppercased())  // → "OLÁ, SWIFT É ÓTIMO!"
        print(frase.lowercased())  // → "olá, swift é ótimo!"

        // contains(_:)
        print(frase.contains("Swift"))    // → true
        print(frase.contains("Java"))     // → false

        // hasPrefix(_:) / hasSuffix(_:)
        print(frase.hasPrefix("Olá"))     // → true
        print(frase.hasSuffix("ótimo!"))  // → true

        // replacingOccurrences(of:with:)
        let novaFrase = frase.replacingOccurrences(of: "ótimo", with: "incrível")
        print(novaFrase)
        // → "Olá, Swift é incrível!"
    }
}

/// Tipo Int
struct IntType {
    static func run() {
        let valor = 10

        // Int.random(in:)
        let aleatorio = Int.random(in: 1...50)
        print(aleatorio)
        // → (número de 1 a 50)

        // advanced(by:)
        let maior = valor.advanced(by: 5)
        print(maior)
        // → 15

        // distance(to:)
        let dist = valor.distance(to: 100)
        print(dist)
        // → 90
    }
}

/// Tipo Float e Double
struct FloatType {
    static func run() {
        let value1: Float  = 3.7
        let value2: Double = 9.81

        // rounded() / rounded(.down)
        print(value1.rounded())             // → 4.0
        print(value2.rounded(.down))        // → 9.0

        // isFinite / isInfinite / isNormal
        print(value1.isFinite)              // → true
        print(value2.isInfinite)            // → false
        print(value2.isNormal)              // → true

        // Float.random(in:) / Double.random(in:)
        let random1 = Float.random(in: 0..<1)
        let random2 = Double.random(in: 0..<1)
        print(random1, random2)
        // → dois valores entre 0.0 e 1.0
    }
}

/// Tipo Booleano
struct BoolType {
    static func run() {
        var flag = true

        // operador ! (not)
        print(!flag)   // → false

        // && (and) / || (or)
        let bool1 = true, bool2 = false
        print(bool1 && bool2)  // → false
        print(bool1 || bool2)  // → true

        // toggle()
        flag.toggle()
        print(flag)    // → false
    }
}

/// Tipo Array
struct ArrayType {
    static func run() {
        var nums = [1, 2, 3]

        // append(_:)
        nums.append(4)
        print(nums)         // → [1,2,3,4]

        // insert(_:at:)
        nums.insert(0, at: 0)
        print(nums)         // → [0,1,2,3,4]

        // remove(at:)
        let rem = nums.remove(at: 2)
        print(rem, nums)    // → 2, [0,1,3,4]

        // first / last / count
        print(nums.first!)  // → 0
        print(nums.last!)   // → 4
        print(nums.count)   // → 4

        // contains(_:)
        print(nums.contains(3))  // → true

        // map(_:)
        let dobro = nums.map { $0 * 2 }
        print(dobro)             // → [0,2,6,8]

        // filter(_:)
        let pares = nums.filter { $0 % 2 == 0 }
        print(pares)             // → [0,4]

        // reduce(_:_:)
        let soma = nums.reduce(0, +)
        print(soma)              // → 8
    }
}

/// Tipo Dicionario
struct DictType {
    static func run() {
        var info: [String: Int] = ["idade": 25, "peso": 70]

        // updateValue(_:forKey:)
        info.updateValue(75, forKey: "peso")
        print(info)
        // → ["idade":25, "peso":75]

        // removeValue(forKey:)
        let old = info.removeValue(forKey: "idade")
        print(old!, info)
        // → 25, ["peso":75]

        // keys / values
        print(Array(info.keys))    // → ["peso"]
        print(Array(info.values))  // → [75]

        // filter(_:)   (retorna pares chave-valor)
        let grandes = info.filter { $0.value > 50 }
        print(grandes)             // → ["peso":75]

        // mapValues(_:)
        let emKg = info.mapValues { "\($0)kg" }
        print(emKg)                // → ["peso":"75kg"]
    }
}

/// Tipo Set
struct SetType {
    static func run() {
        var letras: Set = ["a", "b", "c"]

        // insert(_:)
        letras.insert("d")
        print(letras)              // → ["a","b","c","d"]

        // remove(_:)
        letras.remove("b")
        print(letras)              // → ["a","c","d"]

        // contains(_:)
        print(letras.contains("a"))  // → true

        // union(_:)
        let outro: Set = ["c", "e"]
        print(letras.union(outro))   // → ["a","c","d","e"]

        // intersection(_:)
        print(letras.intersection(outro))  // → ["c"]

        // subtracting(_:)
        print(letras.subtracting(outro))   // → ["a","d"]
    }
}

/// Tipo Tupla
struct TupleType {
    static func run() {
        let pessoa: (nome: String, idade: Int) = ("Maria", 30)

        // acesso por nome
        print(pessoa.nome)  // → "Maria"
        print(pessoa.idade) // → 30

        // desestruturação
        let (nome, idade) = pessoa
        print(nome, idade)  // → "Maria" 30
    }
}

/// Tipo qualquer coisa
struct AnyType {
    static func run() {
        var qualquer: Any = "texto"
        qualquer = 99

        // downcast com as? / as!
        if let anyString = qualquer as? String {
            print("String:", anyString)
        } else if let anyInt = qualquer as? Int {
            print("Int:", anyInt)            // 99
        }

        // AnyObject (classes)
        class Foo { let myValue = 5 }
        let arr: [AnyObject] = [Foo()]
        if let obj = arr.first as? Foo {
            print(obj.myValue)  // → 5
        }
    }
}
