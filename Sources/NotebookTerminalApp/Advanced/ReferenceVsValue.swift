// Vamos ver a passagem por referência (Classes) vs passagem por valor (Structs)

import AppKit
import ArgumentParser

struct ReferenceVsValueCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "refvsval",
        abstract: "Tutorial sobre passagem por referência vs valor em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        referenceVsValueRunner()
    }
}

class ClassHero {
    var name: String
    var universe: String
    
    init(name: String, universe: String) {
        self.name = name
        self.universe = universe
    }
}


struct StructHero {
    var name: String
    var universe: String
}


func referenceVsValueRunner() {
    let ironMan = ClassHero(name: "Iron Man", universe: "Marvel")
    // Passagem por referencia vc ta modificando o proprio ironMan para se tornar o Hulk
    let ironManClone = ironMan
    ironManClone.name = "Hulk"
    print("Hero \(ironMan.universe) \(ironMan.name)")                   // Hero Marvel Hulk
    print("Hero Clone \(ironManClone.universe) \(ironManClone.name)")   // Hero Clone Marvel Hulk
    
    let superMan = StructHero(name: "Super Man", universe: "DC")
    // Passagem por valor vc fazendo uma copia exata do Super Man e chamando de Batman
    var superManClone = superMan
    superManClone.name = "Batman"
    print("Hero \(superMan.universe) \(superMan.name)")                                      // Hero DC SuperMan
    print("Hero Clone \(superManClone.universe) \(superManClone.name)")                           // Hero Clone DC Batman
}
