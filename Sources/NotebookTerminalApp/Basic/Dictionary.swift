// Dicionarios sao dados armazenados com tipo [chave: valor]
// Dicionarios podem ter tipagens diferentes de usado [String: Any]

import AppKit
import ArgumentParser

struct DictionaryCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "dictionary",
        abstract: "Tutorial sobre dicionarios em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Criação de dicionários:")
        CriacaoDeDicionarios.run()
        print("→ Acessando Valores:")
        AcessandoValores.run()
        print("→ Adicionando e atualizando entradas:")
        AdicionandoAtualizandoEntradas.run()
        print("→ Removendo entradas:")
        RemovendoEntradas.run()
        print("→ Iterando sobre dicionários:")
        IterandoSobreDict.run()
        print("→ Transformando e filtrando:")
        TransformandoEFiltrando.run()
        print("→ Mesclando dicionários:")
        MesclandoDict.run()
        print("→ Ordenando dicionários:")
        Ordenando.run()
    }
}

/// Criação de Dicionarios
fileprivate struct CriacaoDeDicionarios {
    static func run() {
        // Dicionário vazio (tipo explícito)
        let emptyDict: [String: Int] = [:]
        print(emptyDict)               // [:]

        // Dicionário com valores iniciais
        let personInfo: [String: String] = [
            "firstName": "Alice",
            "lastName": "Silva"
        ]
        print(personInfo)               // ["firstName": "Alice", "lastName": "Silva"]

        // Dicionário com tipos mistos (Any)
        let mixedDict: [String: Any] = [
            "name": "Bob",
            "age": 30,
            "isMember": true
        ]
        print(mixedDict)                // ["isMember": true, "age": 30, "name": "Bob"]

        // Dicionário aninhado
        let hardwareSpecs: [String: [String: Int]] = [
            "desktop": ["cpu": 8, "ram": 16],
            "laptop": ["cpu": 4, "ram": 8]
        ]
        print(hardwareSpecs)            // ["desktop": ["ram": 16, "cpu": 8], "laptop": ["ram": 8, "cpu": 4]]
    }
}

/// Acessando Valores
fileprivate struct AcessandoValores {
    static func run() {
        let personInfo: [String: String] = [
            "firstName": "Alice",
            "lastName": "Silva"
        ]

        // Subscript com default
        print(personInfo["zip"] ?? "00000")             // 00000

        // Forçando unwrap (cuidado com runtime crash)
        print(personInfo["lastName"]!)                  // “Silva”

        // Acesso de dicionário aninhado
        let hardwareSpecs: [String: [String: Int]] = [
            "desktop": ["cpu": 8, "ram": 16],
            "laptop": ["cpu": 4, "ram": 8]
        ]

        if let desktop = hardwareSpecs["desktop"],
           let ram = desktop["ram"] {
            print("RAM do desktop: \(ram) GB")
        }
    }
}

/// Adicionando e atualizando entradas
fileprivate struct AdicionandoAtualizandoEntradas {
    static func run() {
        var scores: [String: Int] = [:]

        // 1) Atribuição direta (cria ou atualiza)
        scores["Alice"] = 95    // cria
        print(scores)           // [Alice: 95]
        scores["Alice"] = 98    // atualiza
        print(scores)           // [Alice: 98]

        // 2) Método updateValue(_:forKey:)
        // retorna o valor antigo se existente
        if let oldScore = scores.updateValue(100, forKey: "Alice") {
            print("Pontuação anterior: \(oldScore)") // Pontuação anterior: 98
        }
        print("Nova pontuação: \(scores["Alice"]!)") // Nova pontuação 100
    }
}

/// Removendo entradas
fileprivate struct RemovendoEntradas {
    static func run() {
        var scores: [String: Int] = ["Alice": 85, "Bob": 100]
        print(scores)               // [Alice: 85, Bob: 100]

        // 1) Subscript para nil (remove)
        scores["Alice"] = nil
        print(scores)               // [Bob: 100]

        // 2) removeValue(forKey:)
        if let removed = scores.removeValue(forKey: "Bob") {
            print("Removi Bob com pontuação \(removed)")    // Removi bob com pontuação 100
        }
    }
}

/// Iterando sobre dicionários
fileprivate struct IterandoSobreDict {
    static func run() {
        let capitals = ["France": "Paris", "Japan": "Tokyo", "Brazil": "Brasília"]

        // 1) for-in em tuplas (key, value)
        for (country, capital) in capitals {
            print("\(capital) é capital de \(country)")
        }
        // Paris é capital de France
        // Tokyo é capital de Japan
        // Brasília é capital de Brazil

        // 2) só chaves ou só valores
        for country in capitals.keys {
            print(country)
        }
        // France
        // Japan
        // Brazil

        for capital in capitals.values {
            print(capital)
        }
        // Paris
        // Tokyo
        // Brasília
    }
}

/// Transformando e filtrando
fileprivate struct TransformandoEFiltrando {
    static func run() {
        let ages = ["Alice": 30, "Bob": 15, "Carla": 28]
        print(ages)                 // ["Alice": 30, "Bob": 15, "Carla": 28]

        // mapValues: aplica função apenas aos valores
        let agesInFiveYears = ages.mapValues { $0 + 5 }
        print(agesInFiveYears)      // ["Alice": 35, "Bob": 20, "Carla": 33]

        // filter: mantém pares que satisfazem condição
        let adults = ages.filter { $0.value >= 18 }
        print(adults)               // ["Alice": 30, "Carla": 28]

        // compactMapValues: remove valores nil após transformação
        let rawData: [String: String?] = ["a": "1", "b": nil, "c": "3"]
        let ints = rawData.compactMapValues { $0 }
//        let ints = rawData.filter { $0.value != nil }.mapValues { $0! }
        print(ints)                 // ["a": 1, "c": 3]
    }
}

/// Mesclando dicionários
fileprivate struct MesclandoDict {
    static func run() {
        let dictA = ["a": 1, "b": 2]
        let dictB = ["b": 20, "c": 3]

        // Fusão sem conflitos (B prevalece)
        let merged1 = dictA.merging(dictB) { (_, new) in new }
        print(merged1)              // ["a": 1, "b": 20, "c": 3]

        // Fusão com lógica personalizada
        let merged2 = dictA.merging(dictB) { old, new in old + new }
        print(merged2)              // ["a": 1, "b": 22, "c": 3]
    }
}

/// Ordenando
fileprivate struct Ordenando {
    static func run() {
        let capitals = ["France": "Paris", "Japan": "Tokyo", "Brazil": "Brasília"]
        print(capitals)         // ["France": "Paris", "Japan": "Tokyo", "Brazil": "Brasília"]

        // Ordena por chave
        let sortedByKey = capitals.sorted { $0.key < $1.key }
        print(sortedByKey)
        // [(key: "Brazil", value: "Brasília"), (key: "France", value: "Paris"), (key: "Japan", value: "Tokyo")]

        // Ordena por valor
        let sortedByValue = capitals.sorted { $0.value < $1.value }
        print(sortedByValue)
        // [(key: "Brazil", value: "Brasília"), (key: "France", value: "Paris"), (key: "Japan", value: "Tokyo")]
    }
}
