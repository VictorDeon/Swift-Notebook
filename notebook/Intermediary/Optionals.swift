
struct Person {
    var name: String? = "Fulano de Tal"
    func speak() {
        print("Ola mundo!")
    }
}

func optionalRunner() async {
    let fulana = Person()
    // Force Unwrapping! (Perigoso, pq se o valor for nil vai disparar uma exceção)
    // so utilize se tiver certeza que o valor sempres sera preenchido.
    print(fulana.name!)
    
    // Check for nil value (Verifica se o valor e nil)
    if fulana.name != nil {
        print(fulana.name!)
    }
    
    // Optional Binding (Forma mais rapida de se fazer a validação sem usar o force unwrapping)
    if let name = fulana.name {
        print(name)
    }
    
    // Nil Coalescing Operator (Insere um valor defaul caso seja nil
    print(fulana.name ?? "valor default")
    
    // Optional Chaining (Usado em scructs e classes)
    let maria: Person? = Person()
    print(maria?.name ?? "valor default")
    print(maria?.speak() ?? "")
}
