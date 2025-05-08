// Dicionarios sao dados armazenados com tipo [chave: valor]
// Dicionarios podem ter tipagens diferentes de usado [String: Any]

func dictionaryRunner() async {
    // [key: value]
    let dict1: [String: String] = ["zip_code": "111111", "city": "Paris"]
    print(dict1) // ["zip_code": "111111", "city": "Paris"]
    let dict2: [String: Int] = ["age": 22, "height": 70]
    print(dict2) // ["age": 22, "height": 70]
    let dict3: [String: [String: Int]] = ["computer": ["cpu": 10, "memory": 200], "laptop": ["cpu": 20, "memory": 400]]
    print(dict3)
    
    // Acessando os dados de uma dict
    print(dict1["city"])    // Optional("Paris")
    print(dict1["city"]!)   // Paris
    print(dict2["age"]!)    // 22
    print(dict3["computer"]!["cpu"]!)   // 10
    
    // Estrategia de acesso de um dict aninhado que não sebemos se o valor existe.
    if let computer = dict3["computer"] {
        print(computer["cpu"]!)  // 10
    }
}
