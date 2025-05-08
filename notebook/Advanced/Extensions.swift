// Extensions é usado para adicionar novas funcionalidades a classes, structs, protocol ou data-types
// Sintaxe: extension SomeType { ...add new functionality }

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let precision = pow(10.0, Double(places))
        var n = self // 3.14159
        n *= precision
        n = n.rounded()
        n /= precision
        return n
    }
}

func extensionRunner() {
    let myDouble: Double = 3.14159
    
    // Arredonda sempre para o valor antes do decimal (.)
    var myRoundedDouble = myDouble.rounded()
    print(myRoundedDouble) // 3.0
    
    // Quero arredondar apenas a segunda cada decimal ou a casa decimal N
    myRoundedDouble = myDouble.round(to: 1)
    print(myRoundedDouble) // 3.1
    myRoundedDouble = myDouble.round(to: 2)
    print(myRoundedDouble) // 3.14
    myRoundedDouble = myDouble.round(to: 3)
    print(myRoundedDouble) // 3.142
    myRoundedDouble = myDouble.round(to: 4)
    print(myRoundedDouble) // 3.1416
}
