// Loops servem para percorrer objetos
// Closed Range: start...end
// Half Open Range: start..<end
// One Sided Range: ...end

import AppKit
import ArgumentParser

struct LoopCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "loops",
        abstract: "Tutorial sobre loops em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Loop Range:")
        LoopRange.run()
        print("→ Loop String:")
        LoopString.run()
        print("→ Loop Array:")
        LoopArray.run()
        print("→ Loop While:")
        LoopWhile.run()
        print("→ Loop Set:")
        LoopSet.run()
        print("→ Loop Matrix:")
        LoopMatrix.run()
        print("→ Loop Dict:")
        LoopDict.run()
        print("→ Loop Where:")
        LoopWhere.run()
    }
}

struct LoopRange {
    static func run() {
        let start: Int = 1
        let end: Int = 5

        for index in start...10 {
            if index == 3 { continue } // Pula a iteração 3
            if index > 5 { break }  // Ao passar da iteração 5 pare o loop

            print("Iteração \(index)")
            // Iteração 1
            // Iteração 2
            // Iteração 4
            // Iteração 5
        }

        for _ in start..<end {
            print("Ola mundo!")
            // Ola mundo!
            // Ola mundo!
            // Ola mundo!
            // Ola mundo!
        }
    }
}

struct LoopString {
    static func run() {
        for char in "Ola mundo!" {
            print("Letra: \(char)")
            // Letra: O
            // Letra: l
            // Letra: a
            // Letra:
            // Letra: m
            // Letra: u
            // Letra: n
            // Letra: d
            // Letra: o
            // Letra: !
        }
    }
}

struct LoopArray {
    static func run() {
        // Loop vetor (garante a ordem)
        let fruits: [String] = ["pera", "banana", "uva", "uva", "abacate"]
        for fruit in fruits {
            print("Fruta: \(fruit)")
            // Fruta: pera
            // Fruta: banana
            // Fruta: uva
            // Fruta: uva
            // Fruta: abacate
        }
    }
}

struct LoopWhile {
    static func run() {
        var index = 0
        while index < 3 {
            print("While i=\(index)")
            index += 1
            // While i=0
            // While i=1
            // While i=2
        }
    }
}

struct LoopSet {
    static func run() {
        // Loop set (não garante a ordem e valores sao sempre unicos)
        let notRepeatedFruits: Set = ["pera", "banana", "banana", "banana", "abacate"]
        for fruit in notRepeatedFruits {
            print("Fruta: \(fruit)")
            // Fruta: pera
            // Fruta: abacate
            // Fruta: banana
        }
    }
}

struct LoopMatrix {
    static func run() {
        var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        print(matrix)  // [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        for line in 0..<3 {
            for column in 0..<3 {
                matrix[line][column] = line * 3 + column
            }
        }
        print(matrix)  // [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    }
}

struct LoopDict {
    static func run() {
        let contacts: [String: Int] = ["Adam": 123456, "James": 987654, "Amy": 777777]
        for contact in contacts {
            print("\(contact.key): \(contact.value)")
            // James: 987654
            // Adam: 123456
            // Amy: 777777
        }
    }
}

struct LoopWhere {
    static func run() {
        let contacts: [String: Int] = ["Adam": 123456, "James": 987654, "Amy": 777777]
        for contact in contacts where contact.key == "James" {
            print("\(contact.key): \(contact.value)")
            // James: 987654
        }
    }
}
