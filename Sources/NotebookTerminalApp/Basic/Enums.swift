import AppKit

enum WeekDay {
    case monday, tuesday, wednesday, thusday, friday, saturday, sunday
}

enum TestResult {
    case success(String)
    case fail(String)
}

enum Temperature {
    case hot, cold

    func description() -> String {
        switch self {
            case .hot:
                return "Está quente."
            case .cold:
                return "Está frio."
        }
    }
}

enum Status: Int {
    case actived = 1
    case inactived = 0
}

func enumRunner() {
    let today: WeekDay = .monday
    print(today)  // monday
    
    switch today {
        case .monday:
            print("Hoje é segunda-feira")  // Entra aqui
        case .tuesday:
            print("Hoje é terça-feira")
        default:
            print("Outro dia da semana")
    }
    
    let result: TestResult = .success("Teste passou com sucesso!")
    print(result)  // success("Teste passou com sucesso!")

    switch result {
        case .success(let mensagem):
            print(mensagem) // Teste passou com sucesso!
        case .fail(let erro):
            print(erro)
    }
    
    let clime = Temperature.hot
    print(clime.description())  // Está quente.
    
    let status = Status.actived
    print(status.rawValue)      // 1
}


