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
        typeRunner()
    }
}

class MyAnimal {
    let name: String = "gato"
}

class MyFruit {}

func typeRunner() {
    let string: String = "Ola mundo!"
    print(string) // Ola mundo!
    
    let inteiro: Int = 5
    print(inteiro) // 5
    
    let pontoFlutuante: Float = 5.5
    print(pontoFlutuante) // 5.5
    
    let pontoFlutuanteDuplo: Double = 1.14156
    print(pontoFlutuanteDuplo) // 1.14156
    
    let booleano: Bool = true
    print(booleano) // true
    
    let vetor: [Int] = [1, 2, 3, 4, 5]
    print(vetor) // [1, 2, 3, 4, 5]
    
    let dicionario: [String: Int] = ["age": 18, "weight": 70]
    print(dicionario) // ["age": 18, "weight": 70]
    
    let vetorSemRepeticao: Set = [1, 2, 3, 3, 4, 5, 4, 5, 6]
    print(vetorSemRepeticao)  // [1, 2, 4, 5, 3, 6]
    
    let animal: MyAnimal = MyAnimal()
    print(animal.name) // gato
    
    var qualquerCoisa: Any = "Oloko meu"
    print(qualquerCoisa) // Oloko meu
    qualquerCoisa = 10
    print(qualquerCoisa) // x
    
    let qualquerObjeto: [AnyObject] = [animal, MyFruit()]
    print(qualquerObjeto)  // [notebook.MyAnimal, notebook.MyFruit]
}
