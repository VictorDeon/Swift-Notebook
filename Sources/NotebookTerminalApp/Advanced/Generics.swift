// Generics permite você criar códigos reusaveis

import Foundation
import AppKit
import ArgumentParser

struct GenericsCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "generics",
        abstract: "Tutorial sobre generics em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        /// O Array utiliza Generic para deficir qual o tipo de dados dentro do array, no caso Int
        let numberArray: Array<Int> = [1, 2, 3, 4, 5]
        print(numberArray) // [1, 2, 3, 4, 5]
        
        let mergedString = mergeTogether(a: "Ola", b: "Mundo")
        print(mergedString)  // ["Ola", "Mundo"]
        
        let mergedInts = mergeTogether(a: 10, b: 20)
        print(mergedInts) // [10, 20]
        
        let myDict = createDict(a: "Chave", b: 10)
        print(myDict) // ["Chave": 10]
        
        let firstInFirstOutQueue = Queue(head: 10)
        firstInFirstOutQueue.enqueue(5)
        firstInFirstOutQueue.enqueue(9)
        firstInFirstOutQueue.enqueue(20)
        print(firstInFirstOutQueue) // [10, 5, 9, 20]
        print(firstInFirstOutQueue.dequeue() ?? "Não tem nada dentro da queue") // 10
        print(firstInFirstOutQueue) // [5, 9, 20]
        print(firstInFirstOutQueue.peek() ?? "Não tem nada dentro da queue") // 5
        
        let same: Bool = isTheSame(a: 10, b: 10)
        print(same) // True
    }
}

/// T pode ser qualquer tipo, ele é um tipo generico.
func mergeTogether<T>(a: T, b: T) -> [T] {
    return [a, b]
}

func createDict<T, U>(a: T, b: U) -> [T: U] {
    return [a: b]
}

/// Aqui estamos aplicando uma constraint dizendo que o tipo que deve ser enviado para essa função tem que ser Equatable
func isTheSame<T: Equatable>(a: T, b: T) -> Bool {
    return a == b
}

class Queue<T> {
    private var storage: [T] = []
    
    init(head: T) {
        storage = [head]
    }
    
    func enqueue(_ element: T) {
        storage.append(element)
    }
    
    func peek() -> T? {
        guard !storage.isEmpty else { return nil}
        return storage[0]
    }
    
    func dequeue() -> T? {
        guard !storage.isEmpty else { return nil}
        return storage.remove(at: 0)
    }
}

/// Podemos colocar constraints no extension: extension ABC where T: XYZ { ... }
/// Estamos dizendo que para os metodos definidos nessa extensão da classe ABC o tipo tem que ser XYZ para executa-lo.
extension Queue: CustomStringConvertible {
    public var description: String {
        // Converte cada elemento para String e junta com ", "
        let content = storage.map { String(describing: $0) }
                              .joined(separator: ", ")
        return "[\(content)]"
    }
}

extension Queue: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Queue(\(description))"
    }
}
