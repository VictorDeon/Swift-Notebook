/*
 Em Swift, às vezes trabalhamos com coleções de objetos de uma classe base (por exemplo, Animal),mas precisamos
 chamar métodos específicos de subclasses (por exemplo, Human.code() ou Fish.breatheUnderWater()). Para isso, usamos:
    * Upcast: tratar um objeto como sendo de sua superclasse.
    * Downcast: converter um Animal de volta para Human ou Fish.
 Swift oferece três operadores:
    is:  Verifica em tempo de execução se o objeto é de um tipo específico
    as:  Upcast             - converte para um tipo de superclasse (sempre seguro)
    as?: Downcast opcional  - retorna nil se falhar (safe cast)
    as!: Downcast forçado   - causa runtime crash se falhar (force cast)
 Boas Práticas:
    1. Evite as! sempre que possível. Prefira as? e trate o nil.
    2. Use switch para centralizar a lógica de type casting.
    3. Mantenha seu modelo de classes claro: quanto menos herança profunda, menores as chances de erro.
    4. Considere protocolos em vez de herança para compartilhar comportamentos (ex, protocol Coder { func code() }).
*/

import Foundation
import AppKit
import ArgumentParser

struct CastingCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "casting",
        abstract: "Tutorial sobre casting em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Upcasting:")
        Upcasting.run()
        print("→ Verificando tipo:")
        VerificandoTipo.run()
        print("→ Downcasting Inseguro:")
        DowncastingInseguro.run()
        print("→ Downcasting Seguro:")
        DowncastingSeguro.run()
        print("→ Type Casting com Switch:")
        TypeCastingComSwitch.run()
    }
}

// MARK: - Classes de exemplo

class Animal {
    let name: String
    init(name: String) { self.name = name }
}

class Human: Animal {
    func code() {
        print("\(name) está codando.")
    }
}

class Fish: Animal {
    func breatheUnderWater() {
        print("\(name) está respirando embaixo d’água.")
    }
}

/// Sempre seguro
struct Upcasting {
    static func run() {
        let jack = Human(name: "Jack Bauer")
        // Tratamos o 'jack' como Animal
        let animal: Animal = jack as Animal
        print("\(animal.name) como Animal")  // Jack Bauer como Animal
        // Obs. O upcast com as nunca falha, pois toda subclasse herda de sua superclasse.
    }
}

/// Verificando tipo com is
struct VerificandoTipo {
    static func run() {
        let jack = Human(name: "Jack Bauer")
        let creatures: [Animal] = [jack, Fish(name: "Nemo")]

        for creature in creatures {
            if creature is Fish {
                print("\(creature.name) é um peixe!")
            }
        }
    }
}

/// Downcasting inseguro com as!
struct DowncastingInseguro {
    static func run() {
        let jack = Human(name: "Jack Bauer")
        let creatures: [Animal] = [jack, Fish(name: "Nemo")]
        let nemo = creatures[1]
        // Sabemos que creatures[1] é Fish, então:
        // swiftlint:disable:next force_cast
        let fish = nemo as! Fish
        fish.breatheUnderWater()  // Nemo está respirando embaixo d’água.
    }
}

/// Downcasting seguro com as?
struct DowncastingSeguro {
    static func run() {
        let jack = Human(name: "Jack Bauer")
        let creatures: [Animal] = [jack, Fish(name: "Nemo")]
        if let maybeFish = creatures[0] as? Fish {
            maybeFish.breatheUnderWater()
        } else {
            print("\(creatures[0].name) não é um peixe.")
        }
    }
}

/// Type Casting com switch
struct TypeCastingComSwitch {
    static func run() {
        let jack = Human(name: "Jack Bauer")
        let creatures: [Animal] = [jack, Fish(name: "Nemo")]
        // Isso deixa o código mais limpo e evita vários if let … as? … else.
        for creature in creatures {
            switch creature {
            case let human as Human:
                human.code()
            case let fish as Fish:
                fish.breatheUnderWater()
            default:
                print("\(creature.name) é um Animal genérico")
            }
        }
    }
}
