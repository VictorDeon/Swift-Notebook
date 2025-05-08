// Funções seguem a seguinte sintaxe: func MyFunc(external internal: type, ...) -> returnType { ...code }

// Parametros nomeados iguais Externamente e Internamente
func sum1(n1: Int, n2: Int) -> Int {
    return n1 + n2
}

// Parametros nao nomeados
func sum2(_ n1: Int, _ n2: Int) -> Int {
    return n1 + n2
}

// Parametros nomeados diferentes Externamente e Internamente
func sum3(n1 number1: Int, n2 number2: Int) -> Int {
    return number1 + number2
}

// Parametros nomeados e Nao nomeados na mesma função
func sum4(_ n1: Int, n2: Int) -> Int {
    return n1 + n2
}

// Função sem retorno e sem parâmetros
func printHello() -> Void {
    print("Hello World!")
}


func functionRunner() {
    print(sum1(n1: 1, n2: 2))   // 3
    print(sum2(1, 2))           // 3
    print(sum3(n1: 1, n2: 2))   // 3
    print(sum4(1, n2: 2))       // 3
    printHello()
}
