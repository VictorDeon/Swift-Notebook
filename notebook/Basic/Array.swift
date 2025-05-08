// Arrays sao dados armazenados em um vetor ou matriz multidimensional
// Arrays podem ter tipos diferentes dentro dele se a tipagem for [Any]

func arrayRunner() {
    // [value1, value2, ...]
    let array1: [String] = ["Fulano 01", "Fulano 02", "Fulano 03"]
    print(array1) // ["Fulano 01", "Fulano 02", "Fulano 03"]
    let array2: [Int] = [1, 2, 3, 4, 5]
    print(array2) // [1, 2, 3, 4, 5]
    
    // Acessando os dados de uma array
    print(array1[0])    // Fulano 01
    print(array1[1])    // Fulano 02
    print(array2[4])    // 5
    
    // array bidimensional
    let matriz: [[Int]] = [[1, 2, 3], [5, 2], [2, 3, 4]]
    print(matriz)  // [[1, 2, 3], [5, 2], [2, 3, 4]]
    
    // Acessando os dados de uma matriz
    print(matriz[0])        // [1, 2, 3]
    print(matriz[0][0])     // 1
    print(matriz[1])        // [5, 2]
    print(matriz[1][0])     // 5
    
    // Podemos ter matrizes com N dimensoes
    let m: [[[Int]]] = [[[1, 2], [3, 4]], [[5, 6], [7]]]
    print(m[1][0][1])  // 6
}

