// Tratamento de exceçoes
import Foundation
import AppKit
import ArgumentParser

// 1) Definição de erros, agora conformando a LocalizedError
enum MathError: LocalizedError {
    case divisionByZero
    case negativeNumerator
    case other(message: String)

    var errorDescription: String? {
        switch self {
        case .divisionByZero:
            return "Erro: tentativa de divisão por zero."
        case .negativeNumerator:
            return "Erro: o numerador não pode ser negativo."
        case .other(let message):
            return message
        }
    }
}

struct ExceptionCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "exceptions",
        abstract: "Tutorial sobre tratamento de exceção em swift"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .shortAndLong,  // -n --numerador
        help: "numerador da divisão"
    )
    var numerador: Int

    @Option(
        name: .shortAndLong,  // -d --denominador
        help: "denominador da divisão"
    )
    var denominador: Int

    func run() throws {
        // Exemplo de uso de try? para receber resultado opcional
        if let resultadoOpcional = try? divide(numerador, by: denominador) {
            print("→ Resultado (try?): \(resultadoOpcional)")
        }

        // Uso completo de do-catch
        do {
            let resultado = try divide(numerador, by: denominador)
            print("→ Resultado (do-catch): \(resultado)")
        } catch let error as MathError {
            // captura erros específicos de MathError
            print(error.localizedDescription)
        } catch {
            // fallback para qualquer outro Error
            print("Erro inesperado: \(error.localizedDescription)")
        }

        do {
            let result = try applyOperation(numerador, denominador, operation: divide)
            print("→ Resultado (rethrowing): \(result)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

// 3) Função de divisão com múltiplas validações
func divide(_ numerador: Int, by denominador: Int) throws -> Int {
    // pré-condição: denominador não pode ser zero
    guard denominador != 0 else {
        throw MathError.divisionByZero
    }
    // pré-condição adicional: numerador não negativo (exemplo)
    guard numerador >= 0 else {
        throw MathError.negativeNumerator
    }
    return numerador / denominador
}

// 4) Exemplo de função rethrowing, para mostrar como propagar erros
func applyOperation<T>(_ value1: Int, _ value2: Int, operation: (Int, Int) throws -> T) rethrows -> T {
    return try operation(value1, value2)
}
