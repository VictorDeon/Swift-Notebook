import AppKit
import ArgumentParser

struct SingleResponsabilityPrincipleCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "single-responsability-principle",
        abstract: "Cada classe/dependência deve ter apenas uma responsabilidade."
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let calculator = OrderCalculator()
        let repository = OrderRepository()
        let emailService = EmailService()

        let total = calculator.total(for: [203.40, 202.10, 22.30])
        repository.save(total)
        emailService.sendConfirmation(to: "fulano@gmail.com")
    }
}

/// Aqui OrderManager faz cálculo, persistência e envio de e-mail: responsabilidade demais.
fileprivate class OrderManager {
    func calculateTotal(for items: [Double]) -> Double {
        return items.reduce(0) { $0 + $1 }
    }
    
    func saveOrder(_ order: Any) {
        print("Pedido sendo salvo no banco de dados.")
    }
    
    func sendConfirmationEmail(to email: String) {
        print("Enviando email para \(email)")
    }
}

// 1. Responsabilidade: cálculo
fileprivate class OrderCalculator {
    func total(for items: [Double]) -> Double {
        items.reduce(0) { $0 + $1 }
    }
}

// 2. Responsabilidade: persistência
fileprivate class OrderRepository {
    func save(_ order: Any) {
        print("Pedido sendo salvo no banco de dados.")
    }
}

// 3. Responsabilidade: comunicação
fileprivate class EmailService {
    func sendConfirmation(to email: String) {
        print("Enviando email para \(email)")
    }
}
