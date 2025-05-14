import AppKit
import ArgumentParser

struct OptionalCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "optionals",
        abstract: "Tutorial sobre opcionais em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Force Unwrapping!")
        ForceUnwrapping.run()
        print("→ Check for nil value")
        CheckForNilValue.run()
        print("→ Optional Binding")
        OptionalBinding.run()
        print("→ Nil Coalescing Operator")
        NilCoalescingOperator.run()
        print("→ Optional Chaining")
        OptionalChaining.run()
    }
}

struct Person {
    var name: String? = "Fulano de Tal"
    var email: String? = "fulano@gmail.com"
    func speak() {
        print("Ola mundo!")
    }
}

/// Force Unwrapping! (Perigoso, pq se o valor for nil vai disparar uma exceção)
/// so utilize se tiver certeza que o valor sempres sera preenchido.
struct ForceUnwrapping {
    static func run() {
        let fulana = Person()
        print(fulana.name!)
    }
}

/// Check for nil value (Verifica se o valor e nil)
struct CheckForNilValue {
    static func run() {
        let fulana = Person()

        if fulana.name != nil {
            print(fulana.name!)
        }
    }
}

/// Optional Binding (Forma mais rapida de se fazer a validação sem usar o force unwrapping)
struct OptionalBinding {
    static func run() {
        let cicrana = Person()
        let fulana = Person()

        if let name = fulana.name,
           let email = cicrana.email {
            print(name, email)
        }
    }
}

/// Nil Coalescing Operator (Insere um valor defaul caso seja nil
struct NilCoalescingOperator {
    static func run() {
        let fulana = Person()
        print(fulana.name ?? "valor default")
    }
}

/// Optional Chaining (Usado em scructs e classes)
struct OptionalChaining {
    static func run() {
        let maria: Person? = Person()
        print(maria?.name ?? "valor default")
        print(maria?.speak() ?? "")
    }
}

