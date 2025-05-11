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

func conditionalRunner() {
    let age: Int = 20

    if age > 70 {
        print("Muito velho para dirigir.")
    } else if age > 18 {
        print("Pode dirigir")
    } else {
        print("Muito novo para dirigir")
    }
    
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

    let hardness: String = "Medium"

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
