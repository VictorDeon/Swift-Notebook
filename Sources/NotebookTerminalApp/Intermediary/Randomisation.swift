// Vamos trabalhar com os métodos randomicos

import AppKit
import ArgumentParser

struct RandomCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "randoms",
        abstract: "Tutorial sobre randoms em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print(Int.random(in: 1...5))    // 1 ou 2 ou 3 ou 4 ou 5
        print(Bool.random())            // true ou false
        var myArray = ["a", "e", "i", "o", "u"]
        print(myArray.randomElement()!) // a ou e ou i ou o ou u
        print(myArray.shuffle())        // Embaralha o array
    }
}
