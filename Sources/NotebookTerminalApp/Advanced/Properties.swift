/*
 Em Swift, além de propriedades armazenadas (stored properties), podemos usar:
    - Store Properties: Sao as variaveis tipicas de uma struct ou classe, armazenam o valor dentro delas.
    - Lazy Properties: São valores armazenados na qual seu valor é calculado somente apos a primeira vez de uso.
    - Computed Properties (Propriedades Computadas): não armazenam um valor diretamente, mas calculam-no
      dinamicamente a cada acesso.
        1. Declaração obrigatoriamente em var.
        2. Podem ter getter e (opcionalmente) setter.
        3. Se só houver getter, são read-only.
    - Property Observers (Observadores de Propriedade): permitem reagir a mudanças de valor em uma propriedade
      armazenada, executando código em willSet e/ou didSet.
        1. Só funcionam em propriedades armazenadas.
        2. willSet roda antes de alterar o valor (acessa newValue).
        3. didSet roda depois de alterar o valor (acessa oldValue e o novo valor pelo seu nome).
*/

import Foundation
import AppKit
import ArgumentParser

struct PropertiesCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "properties",
        abstract: "Tutorial sobre computed attributes em swift"
    )

    @OptionGroup var common: CommonOptions

    @Option(name: .long, help: "Total de pedaços por pizza.")
    var slicesPerPizza: Int = 8

    @Option(name: .long, help: "Número de pessoas que vão comer pizza.")
    var numberOfPeople: Int = 5

    @Option(name: .long, help: "Quantidade de pedaços desejados por pessoa.")
    var slicesPerPerson: Int = 3

    func run() throws {
        let calculator = PizzaCalculator(
            slicesPerPizza: slicesPerPizza,
            numberOfPeople: numberOfPeople,
            slicesPerPerson: slicesPerPerson
        )
        calculator.printResults()
        // ➡️ Precisamos de 2 pizza(s) para 5 pessoa(s).
        // ⚠️ Atenção: haverá desperdício de pizza!
        // 🍕 Sobrou 1 pedaço(s) de pizza.
    }
}

fileprivate struct PizzaCalculator {
    // 1) Stored property com Property Observers
    // Uma propriedade armazenada leftoverSlices com observers para notificar desperdício.
    private(set) var leftoverSlices: Int = 0 {
        willSet {
            print("⚠️ Atenção: haverá desperdício de pizza!")
        }
        didSet {
            print("🍕 Sobrou \(leftoverSlices) pedaço(s) de pizza.")
        }
    }
    
    // Vai ter um resultado dependendo do resultado do didSet acima.
    lazy var temDesperdicio: Bool = {
        if leftoverSlices <= 0 {
            return false
        }
        
        return true
    }()

    // Propriedades recebidas via inicialização
    let slicesPerPizza: Int
    let numberOfPeople: Int
    let slicesPerPerson: Int

    // 2) Computed property: calcula pizzas necessárias
    // Uma propriedade computada pizzasNeeded que calcula quantas pizzas comprar.
    var pizzasNeeded: Int {
        get {
            // Total de pedaços necessários
            let totalNeeded = numberOfPeople * slicesPerPerson
            // Quantas pizzas inteiras precisamos (arredonda pra cima)
            let pizzas = Int(ceil(Double(totalNeeded) / Double(slicesPerPizza)))
            return pizzas
        }
        set {
            // Ao atribuir um novo valor, calculamos desperdício
            let totalSlices = newValue * slicesPerPizza
            leftoverSlices = totalSlices - (numberOfPeople * slicesPerPerson)
        }
    }

    // 3) Método para exibir resultados
    func printResults() {
        // Executa o getter
        print("➡️ Precisamos de \(pizzasNeeded) pizza(s) para \(numberOfPeople) pessoa(s).")
        // Agora executa o setter para disparar os observers
        // (reaproveitamos o mesmo valor para cálculo de sobra)
        var mutableSelf = self
        mutableSelf.pizzasNeeded = pizzasNeeded
        print(mutableSelf.temDesperdicio) // true
    }
}
