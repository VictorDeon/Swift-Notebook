import AppKit
import ArgumentParser

struct OpenClosePrincipleCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "open-closed-principle",
        abstract: "Aberto para extensão, fechado para modificação."
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let service = DiscountService(strategy: SummerDiscount())
        let result = service.apply(to: 100)
        print(result) // 90.0
    }
}

// Antes da refatoração
// Toda vez que adiciona um novo tipo, modifica-se DiscountService.
class DiscountServiceInvalid {
    func applyDiscount(amount: Double, type: String) -> Double {
        switch type {
        case "summer":
            return amount * 0.9
        case "winter":
            return amount * 0.8
        default:
            return amount
        }
    }
}

// Para novas políticas, basta criar novas DiscountStrategy, sem tocar em DiscountService.
protocol DiscountStrategy {
    func apply(to amount: Double) -> Double
}

class SummerDiscount: DiscountStrategy {
    func apply(to amount: Double) -> Double { amount * 0.9 }
}

class WinterDiscount: DiscountStrategy {
    func apply(to amount: Double) -> Double { amount * 0.8 }
}

class DiscountService {
    private let strategy: DiscountStrategy

    init(strategy: DiscountStrategy) {
        self.strategy = strategy
    }

    func apply(to amount: Double) -> Double {
        strategy.apply(to: amount)
    }
}
