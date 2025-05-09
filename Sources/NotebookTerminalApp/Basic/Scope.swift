// Escopo
func scopeRunner() async {
    var y = 5 // var é para variaveis mutaveis.
    print(y) // 5
    var x = 10 // Escopo Local
    
    func myLocalFunction() {
        let z = 10  // Como o z não é modificado em local nenhum usamos o let para considera-lo uma constante imutavel.
        print(x, y) // 10, 5
        x = 20
        print(x) // 20
        print(z) // 10
    }
    
    myLocalFunction()
    
    print(x) // 20
    // print(z) // Não conseguimos ver a variavel z pois ela esta dentro do escopo da função.
}
