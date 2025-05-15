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
            let myCar = CarSingleton()
            myCar.colour = "Blue"

            let yourCar = CarSingleton()
            print("My Car Colour: \(myCar.colour)")     // Blue
            print("Your Car Colour: \(yourCar.colour)") // Red (outra instancia, pega o valor default)
            
            let myCarSingleton = CarSingleton.shared
            myCarSingleton.colour = "Blue"

            let yourCarSingleton = CarSingleton.shared
            print("My Car Singleton Colour: \(myCarSingleton.colour)")      // Blue
            print("Your Car Singleton Colour: \(yourCarSingleton.colour)")  // Blue (é a mesma instancia singleton)
            
            let settings = SingletonSettings.shared
            print(settings.lang!)
        }
    }
}

/// Singleton que permite modificação de seus atributos e instanciaçoes da classe
class CarSingleton {
    var colour = "Red"
    
    // Precisamos enviar para a thread principal para evitar concorrencia ao modificar os dados desse singleton.
    @MainActor static let shared = CarSingleton()
}

/// Singleton que não permitie modificação ou instanciações
class SingletonSettings {
    let lang: String = "pt-BR"
    
    // Definie a forma de acesso as configurações
    @MainActor static let shared = Settings()
    
    // Impede de inicializar uma nova instancia das configurações.
    private init() {}
}
