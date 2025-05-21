import AppKit
import ArgumentParser

struct DependencyInversionPrincipleCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "dependency-inversion-principle",
        abstract: "Dependa de abstrações, não de implementações."
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let checkoutWithPayPal = Checkout(service: PaypalService())
        checkoutWithPayPal.processPayment(amount: 120.30)
        let checkoutWithStripe = Checkout(service: StripeService())
        checkoutWithStripe.processPayment(amount: 120.30)
    }
}

// Antes da Refatoração
// Checkout está acoplado diretamente a PaypalService
fileprivate class PaypalServiceInvalid {
    func pay(amount: Double) { /* chama API do PayPal */ }
}

fileprivate class CheckoutInvalid {
    private let paypal = PaypalServiceInvalid()

    func processPayment(amount: Double) {
        paypal.pay(amount: amount)
    }
}

// Depois da refatoração
// Checkout depende da abstração PaymentService, permitindo trocar implementações facilmente.
fileprivate protocol PaymentService {
    func pay(amount: Double)
}

fileprivate class PaypalService: PaymentService {
    func pay(amount: Double) {
        print("Chamando a API da PayPal...")
    }
}

fileprivate class StripeService: PaymentService {
    func pay(amount: Double) {
        print("Chamando a API da Stripe...")
    }
}

fileprivate class Checkout {
    private let paymentService: PaymentService

    init(service: PaymentService) {
        self.paymentService = service
    }

    func processPayment(amount: Double) {
        paymentService.pay(amount: amount)
    }
}
