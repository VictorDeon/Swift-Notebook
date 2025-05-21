import AppKit
import ArgumentParser

struct InterfaceSegregationPrincipleCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "interface-segregation-principle",
        abstract: "Múltiplas interfaces específicas são melhores do que uma única interface geral."
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let human = HumanWorker()
        human.work()
        human.eat()
        let robo = RobotWorker()
        robo.work()
    }
}

// Antes da Refatoração
// RobotWorker é forçado a implementar eat() sem sentido.
fileprivate protocol Worker {
    func work()
    func eat()
}

fileprivate class HumanWorkerInvalid: Worker {
    func work() { /* trabalha */ }
    func eat() { /* faz pausa para comer */ }
}

fileprivate class RobotWorkerInvalid: Worker {
    func work() { /* trabalha */ }
    func eat() { /* Robô não come! */ }
}

// Depois da refatoração
// Cada classe implementa apenas o que faz sentido para ela.
fileprivate protocol Workable {
    func work()
}

fileprivate protocol Feedable {
    func eat()
}

fileprivate class HumanWorker: Workable, Feedable {
    func work() { print("Sou um humano trabalhando...") }
    func eat() { print("Realizando uma pausa para comer") }
}

fileprivate class RobotWorker: Workable {
    func work() { print("Sou um robo trabalhando sem pausa...") }
}
