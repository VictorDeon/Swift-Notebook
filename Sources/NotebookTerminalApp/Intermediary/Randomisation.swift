// Vamos trabalhar com os métodos randomicos

import AppKit

func randomRunner() {
    print(Int.random(in: 1...5))    // 1 ou 2 ou 3 ou 4 ou 5
    print(Bool.random())            // true ou false
    var myArray = ["a", "e", "i", "o", "u"]
    print(myArray.randomElement()!) // a ou e ou i ou o ou u
    print(myArray.shuffle())        // Embaralha o array
}
