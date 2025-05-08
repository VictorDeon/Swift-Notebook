// Loops servem para percorrer objetos
// Closed Range: start...end
// Half Open Range: start..<end
// One Sided Range: ...end

func loopRunner() {
    let start: Int = 1
    let end: Int = 5
    
    for i in start...end {
        print("Iteração \(i)")
    }
    
    let fruits: [String] = ["pera", "banana", "uva", "melancia", "abacate"]
    for fruit in fruits {
        print("Fruta: \(fruit)")
    }
}
