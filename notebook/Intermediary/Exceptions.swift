// Tratamento de exceçoes
import Foundation

enum MathError: Error {
    case divisionPerZero
    case invalidInput
    case other(String)
}

func divide(_ numerador: Int, por denominador: Int) throws -> Int {
    // O guard em Swift é usado para fazer verificações de pré-condição,
    // garantindo que uma certa condição seja verdadeira antes de continuar a execução do bloco de código.
    // Se essa condição falhar, você é obrigado a sair do escopo atual
    // seja retornando de uma função, lançando um erro, dando um break num loop.
    guard denominador != 0 else {
        throw MathError.divisionPerZero
        // throw MathError.other("Não divida por zero!")
    }
    return numerador / denominador
}

func exceptionRunner() async {
    do {
        let resultado = try divide(10, por: 0)
        print("Resultado: \(resultado)")
    } catch MathError.divisionPerZero, MathError.invalidInput {
        print("Erro: não é possível dividir por zero.")
    } catch MathError.other(let message) {
        print(message)
    } catch {
        print("Erro desconhecido: \(error)")
    }
}
