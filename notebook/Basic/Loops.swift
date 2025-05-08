// Loops servem para percorrer objetos
// Closed Range: start...end
// Half Open Range: start..<end
// One Sided Range: ...end

func loopRunner() {
    let start: Int = 1
    let end: Int = 5
    
    // Loop Range
    for i in start...end {
        print("Iteração \(i)")
        // Iteração 1
        // Iteração 2
        // Iteração 3
        // Iteração 4
        // Iteração 5
    }
    
    // Loop Range
    for _ in start..<end {
        print("Ola mundo!")
        // Ola mundo!
        // Ola mundo!
        // Ola mundo!
        // Ola mundo!
    }
    
    // Loop string
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
    
    // Loop while
    var i = 0
    while i < 3 {
        print("While i=\(i)")
        i += 1
        // While i=0
        // While i=1
        // While i=2
    }
    
    // Loop set (não garante a ordem e valores sao sempre unicos)
    let notRepeatedFruits: Set = ["pera", "banana", "banana", "banana", "abacate"]
    for fruit in notRepeatedFruits {
        print("Fruta: \(fruit)")
        // Fruta: pera
        // Fruta: abacate
        // Fruta: banana
    }
    
    // Loop matriz
    var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    print(matrix)  // [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    for i in 0..<3 {
        for j in 0..<3 {
            matrix[i][j] = i * 3 + j
        }
    }
    print(matrix)  // [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    
    // Loop dicionarios
    let contacts: [String: Int] = ["Adam": 123456, "James": 987654, "Amy": 777777]
    for contact in contacts {
        print("\(contact.key): \(contact.value)")
        // James: 987654
        // Adam: 123456
        // Amy: 777777
    }
}
