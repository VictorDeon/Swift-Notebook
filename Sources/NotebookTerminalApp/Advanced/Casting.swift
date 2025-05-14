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
        castingRunner()
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

// MARK: Exemplos
func castingRunner() {
    // MARK: Upcasting (sempre seguro)
    let jack = Human(name: "Jack Bauer")
    // Tratamos o 'jack' como Animal
    let animal: Animal = jack as Animal
    print("\(animal.name) como Animal")  // Jack Bauer como Animal
    // Obs. O upcast com as nunca falha, pois toda subclasse herda de sua superclasse.
    
    
    // MARK: Verificando tipo com is
    let creatures: [Animal] = [jack, Fish(name: "Nemo")]

    for creature in creatures {
        if creature is Fish {
            print("\(creature.name) é um peixe!")
        }
    }
    
    // MARK: Downcasting inseguro com as!
    let nemo = creatures[1]
    // Sabemos que creatures[1] é Fish, então:
    let fish = nemo as! Fish
    fish.breatheUnderWater()  // Nemo está respirando embaixo d’água.
    
    // MARK: Downcasting seguro com as?
    if let maybeFish = creatures[0] as? Fish {
        maybeFish.breatheUnderWater()
    } else {
        print("\(creatures[0].name) não é um peixe.")
    }
    
    // MARK: Type casting em switch
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
