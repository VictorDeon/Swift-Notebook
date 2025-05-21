import AppKit
import ArgumentParser

struct LiskovSubstitutionPrincipleCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "liskov-substitution-principle",
        abstract: "Subtipos devem poder substituir seus tipos base sem alterar a corretude do programa."
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        printArea(of: Rectangle(width: 5, height: 10))  // 50
        printArea(of: Square(side: 5))                  // 25
    }
}

// Antes da Refatoração
// Square quebra a expectativa de Rectangle.
fileprivate class RectangleInvalid {
    var width: Double = 0
    var height: Double = 0
    func area() -> Double { width * height }
}

fileprivate class SquareInvalid: RectangleInvalid {
    override var width: Double {
        didSet { height = width }
    }
    override var height: Double {
        didSet { width = height }
    }
}

fileprivate func printArea(of rect: RectangleInvalid) {
    rect.width = 5
    rect.height = 10
    print("Área: \(rect.area())")  // Espera 50, mas com Square dá 25
}

// Depois da refatoração
// Agora ambos respeitam a abstração Shape sem efeitos colaterais.
fileprivate protocol Shape {
    func area() -> Double
}

fileprivate struct Rectangle: Shape {
    let width: Double
    let height: Double
    func area() -> Double { width * height }
}

fileprivate struct Square: Shape {
    let side: Double
    func area() -> Double { side * side }
}

fileprivate func printArea(of shape: Shape) {
    print("Área: \(shape.area())")
}
