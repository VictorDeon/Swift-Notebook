import AppKit
import ArgumentParser

struct EnumCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "enums",
        abstract: "Tutorial sobre enums em swift"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .long,  // today
        help: "Dia da semana. Ex: monday, tuesday, wednesday, thusdaym friday, saturday, sunday"
    )
    var today: WeekDay = .monday

    @Option(
        name: .long,  // temperature
        help: "Dia da semana. Ex: hot, cold"
    )
    var temperature: Temperature = .cold

    @Option(
        name: .customLong("test-result"),  // test-result
        help: "Resultado do teste no formato success:mensagem ou fail:mensagem",
        transform: { (arg: String) throws -> TestResult in
            let parts = arg.split(separator: ":", maxSplits: 1).map(String.init)
            guard parts.count == 2 else {
              throw ValidationError("Use success:… ou fail:…")
            }
            switch parts[0].lowercased() {
            case "success": return .success(parts[1])
            case "fail":    return .fail(parts[1])
            default:        throw ValidationError("Prefixo inválido: use success ou fail")
            }
          }
    )
    var testResult: TestResult = .success("Teste passou com sucesso!")

    @Option(
        name: .long,  // temperature
        help: "Status: 1 ou 0",
            transform: { arg in
                guard let intValue = Int(arg),
                      let status = Status(rawValue: intValue) else {
                    throw ValidationError("Use 1 (ativo) ou 0 (inativo)")
                }
                return status
            }
    )
    var status: Status = .actived

    func run() throws {
        print("→ Enums")
        EnumRunner.run(today: today)
        EnumRunner.run(temperature: temperature)
        EnumRunner.run(status: status)
        EnumRunner.run(result: testResult)
    }
}

fileprivate enum WeekDay: String, CaseIterable, ExpressibleByArgument {
    case monday, tuesday, wednesday, thusday, friday, saturday, sunday
}

fileprivate enum TestResult {
    case success(String)
    case fail(String)
}

fileprivate enum Temperature: String, CaseIterable, ExpressibleByArgument {
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

fileprivate enum Status: Int {
    case actived = 1
    case inactived = 0
}

fileprivate struct EnumRunner {
    static func run(today: WeekDay) {
        switch today {
        case .monday:
            print("Hoje é segunda-feira")  // Entra aqui
        case .tuesday:
            print("Hoje é terça-feira")
        default:
            print("Outro dia da semana: \(today)")
        }
    }
    static func run(result: TestResult) {
        let result: TestResult = result

        switch result {
        case .success(let mensagem):
            print(mensagem) // Teste passou com sucesso!
        case .fail(let erro):
            print(erro)
        }
    }
    static func run(temperature: Temperature) {
        print(temperature.description())  // Está quente.
    }
    static func run(status: Status) {
        print(status.rawValue)      // 1
    }
}
