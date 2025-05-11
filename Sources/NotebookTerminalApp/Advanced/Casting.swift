// Realiza a conversão de um tipo para outro (as, as?, as!, is)
// as   Retorna o objeto ao tipo de sua superclasse
// as!  Transforma o objeto em outra classe tendo certeza que ela é daquele tipo
// as?  Transforma o objeto em outra classe não tendo certeza que ela é daquele tipo
// is   Valida o tipo do objeto.

import Foundation
import AppKit

class Animal {
    var name: String
    
    init(n: String) {
        name = n
    }
}

class Human: Animal {
    func code() {
        print("Estou codando.")
    }
}

class Fish: Animal {
    func breatheUnderWater() {
        print("Respirando em baixo da agua.")
    }
}

func findNemo(from animals: [Animal]) {
    for animal in animals {
        if animal is Fish {
            print(animal.name)          // Nemo
            // Para ter acesso aos atributos e metodos de um peixe temos que fazer o casting. (Force Downcast)
            let fish = animal as! Fish
            fish.breatheUnderWater()    // Respirando em baixo da agua.
        }
    }
}

func castingRunner() {
    let angela = Human(n: "Angela Yu")
    let jack = Human(n: "Jack Bauer")
    let nemo = Fish(n: "Nemo")
    
    let neighbours: [Animal] = [angela, jack, nemo]
    
    // O is verifica qual a tipagem real de um objeto (Type Checking)
    if neighbours[0] is Human {
        print("O primeiro vizinho é um humano")
        // Para codifica o neighbours precisa ser um Humano de fato (Force Downcast)
        let human = neighbours[0] as! Human
        human.code()  // Estou codando.
        // Vamos tranformar o humano em animal novamente. (Upcast)
        let animal = human as Animal
        print(animal.name + " agora é um animal")  // Angela Yu é um animal
    }
    
    findNemo(from: neighbours)
    
    // Se não tiver certeza do que é o tipo do objeto temos que fazer o cast opcional.
    if let fish = neighbours[1] as? Fish {
        print(fish.breatheUnderWater())
    } else {
        print(neighbours[1].name + " não é um peixe")  // Jack Bauer não é um peixe
    }
}
