// Condicionais if, else if, else e switch
// == igual
// != diferente
// > maior que
// < menor que
// >= maior ou igual a
// <= menor ou igual a
// && AND
// || OR
// !  NOT

import AppKit
import ArgumentParser

struct ConditionalCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "conditional",
        abstract: "Tutorial sobre condicionais em swift"
    )

    @OptionGroup var common: CommonOptions
    
    @Option(
        name: .long,  // age
        help: "Idade para dirigir",
        transform: { str in
            // tenta converter, se falhar, lança ValidationError
            guard let n = Int(str), n > 0 else {
                throw ValidationError("Idade ‘\(str)’ não é um inteiro positivo")
            }
            return n
        }
    )
    var age: Int = 20
    
    @Option(
        name: .long,  // hardness
        help: "Tipo da clara do ovo. Ex: Soft, Medium, Hard"
    )
    var hardness: String = "Medium"

    func run() throws {
        conditionalRunner(age: age, hardness: hardness)
    }
}

func conditionalRunner(age: Int, hardness: String) {
    if age > 70 {
        print("Muito velho para dirigir.")
    } else if age > 18 {
        print("Pode dirigir")
    } else {
        print("Muito novo para dirigir")
    }
    
    // if ternario
    let printable = age > 18 ? "Pode dirigir" : "Não pode dirigir"
    print(printable)
    
    switch age {
        case 70...120:  // Closed Range
            print("Muito velho para dirigir")
        case 18..<70: // Half Open Range
            print("Pode dirigir")
        case ...17:   // One Sided Range
            print("Muito novo para dirigir")
        default:
            print("Error, opção inválida.")
    }

    switch hardness {
        case "Soft":
            print("Ovo ta cru")
        case "Medium":
            print("Ovo perfeito")
        case "Hard":
            print("Ovo ta queimado")
        default:
            print("Error, opção inválida.")
    }
}
