// São atributos que são calculados em tempo de uso.

import Foundation
import AppKit
import ArgumentParser

struct ComputedAttributesCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "computed-attributes",
        abstract: "Tutorial sobre computed attributes em swift"
    )

    @OptionGroup var common: CommonOptions
    
    @Option(
        name: .long,  // pizza
        help: "Quantidade total de pedaços da pizza"
    )
    var pizza: Int = 10
    
    @Option(
        name: .long,  // persons
        help: "Quantidade total de pessoas que vão comer pizza"
    )
    var persons: Int = 4
    
    @Option(
        name: .long,  // slices
        help: "Quantidade ideal de pedaços de pizza por pessoa."
    )
    var slices: Int = 3

    func run() throws {
        computerAttributesRunner(pizza, persons, slices)
    }
}

func computerAttributesRunner(_ pizza: Int, _ persons: Int, _ slices: Int) {
    // Observa mudanças nessa variavel e dispara os triggers abaixo
    var slicesLeftOver: Int = 0 {
        willSet {
            print("Vai ter desperdicio de pizza!")
            // Vai ter desperdicio de pizza!
        }
        didSet {
            print("Sobrou \(slicesLeftOver) pedaços de pizza.")
            // Sobrou 1 pedaços de pizza.
        }
    }
    
    // computed properties tem que ser um var e precisa especificar um data type
    // o valor sempre vai mudar a medida que algums colunas mudarem
    // O getter, se esse não tiver um setter ele vai ser read-only
    // O setter é disparado quando atribuimos um valor a variavel com o =
    var numberOfPizza: Int {
        get {
            let numberOfSlicesPerPerson: Double = Double(pizza) / Double(slices)
            let numberOfPizza: Double = Double(persons) / numberOfSlicesPerPerson
            return Int(numberOfPizza)
        }
        set {
            let totalNumberOfSlices: Int = newValue * pizza
            // Executa o observer properties
            slicesLeftOver = totalNumberOfSlices % slices
        }
    }

    // Executa o getter
    print("Precisamos comprar \(numberOfPizza) pizzas para \(persons) pessoas.")
    // Precisamos comprar 27 pizzas para 30 pessoas.

    // Executa o setter
    numberOfPizza = numberOfPizza
}

