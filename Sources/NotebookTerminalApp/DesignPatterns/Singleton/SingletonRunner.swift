// O padrão singleton é usado para que a instância tenha apenas um registro dela, muito usado em configurações
// do sistema e qualquer coisa que não queremos mais de 1 registro sendo feito.
// Exemplos de singleton:
    // UserDefaults.standard
    // URLSession.shared
    // NSApplication.shared

import AppKit
import ArgumentParser

struct SingletonCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "singleton",
        abstract: "Tutorial sobre o padrão de projeto Singleton em swift"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws -> Void {
        // Como estamos rodando um singleton dentro da thread do parsable command
        // precisamos rodar ela na thread principal com o MainActor.run
        await MainActor.run {
            singletonRunner()
        }
    }
}

class Car {
    var colour = "Red"
    
    // Precisamos enviar para a thread principal para evitar concorrencia ao modificar os dados desse singleton.
    @MainActor static let singletonCar = Car()
}

@MainActor func singletonRunner() {
    let myCar = Car()
    myCar.colour = "Blue"

    let yourCar = Car()
    print("My Car Colour: \(myCar.colour)")     // Blue
    print("Your Car Colour: \(yourCar.colour)") // Red (outra instancia, pega o valor default)
    
    let myCarSingleton = Car.singletonCar
    myCarSingleton.colour = "Blue"

    let yourCarSingleton = Car.singletonCar
    print("My Car Singleton Colour: \(myCarSingleton.colour)")      // Blue
    print("Your Car Singleton Colour: \(yourCarSingleton.colour)")  // Blue (é a mesma instancia singleton)
}
