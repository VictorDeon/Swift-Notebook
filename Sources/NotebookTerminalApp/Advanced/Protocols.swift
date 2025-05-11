// Os protocolos sao iguais as interfaces de orientação ao objeto, nela vc define um contrato em que
// todo mundo que o implementar deve seguir.

import AppKit
import ArgumentParser

struct ProtocolCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "protocols",
        abstract: "Tutorial sobre protocolos em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        protocolRunner()
    }
}

protocol CanFlyProtocol {
    func fly()
}

// extensions pode gerar valor default para metodos de um protocolo
extension CanFlyProtocol {
    func fly() {
        print("Algum objeto está voando.")
    }
}

class Bird {
    var isFemale = true
    
    func layEgg() {
        if isFemale {
            print("O passaro está chocando um ovo.")
        }
    }
}

class Eagle: Bird, CanFlyProtocol {
//    func fly() {
//        print("A águia está voando.")
//    }
    
    func soar() {
        print("A águia desliza no ar utilizando as correntes de ar.")
    }
}

class Penguin: Bird {
    func swim() {
        print("O pinguim rema na água")
    }
}

struct Airplane: CanFlyProtocol {
    func fly() {
        print("O avião utiliza seu motor para voar sobre o ar.")
    }
}

struct FlyingMuseum {
    func flyingDemo(_ obj: CanFlyProtocol) {
        obj.fly()
    }
}

func protocolRunner() {
    let eagle = Eagle()
    let penguin = Penguin()
    let airplane = Airplane()
    
    let museum = FlyingMuseum()
    museum.flyingDemo(eagle)
    museum.flyingDemo(airplane)
    penguin.swim()
}
