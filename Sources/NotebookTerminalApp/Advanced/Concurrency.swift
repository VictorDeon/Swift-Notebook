// Concorrencia é a habilidade de rodar multiplos códigos ao mesmo tempo.
// A interface do usuário é executada na thread principal (main thread) enquanto outras tarefas de IO
// bound é executada em background tasks e quando precisa atualizar algo na UI, temos que retornar a main thread.
// As tasks são organizadas em Queue dentro das threads para ser processadas pelo CPU
// serial (UI = MAIN) vs concurrently (NOT UI = GLOBAL)
// Temos algumas prioridades dentro das tasks nesta ordem: Hight, Default, Low, Global Background

import Foundation
import AppKit
import ArgumentParser

struct ConcorrencyCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "concurrency",
        abstract: "Tutorial sobre concorrencia em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() async throws {
        print("→ Execução assincrona 01:")
        RequisicaoAssincrona.run01()
        print("→ Execução assincrona 02:")
        await RequisicaoAssincrona.run02()
        print("→ Execução assincrona 03:")
        await RequisicaoAssincrona.run03()
        print("→ Execução assincrona 04:")
        await RequisicaoAssincrona.run04()
    }
}

struct RequisicaoAssincrona {
    static func run01() {
        print("Antes da requisição no servidor acontecer.")
        URLSession.shared.downloadTask(
            with: URLRequest(
                url: URL(string: "https://httpbin.org/get")!
            )
        ) { _, _, _ in
            print("Dentro da requisição async 01")  // não chega a ver executar pq em CLI ele da um exit(0) antes
        }.resume()
        print("Apos finalizar a requisição.")
    }

    static func run02() async {
        print("Antes da requisição no servidor acontecer.")
        do {
            print("Dentro da requisição async 02")
            let result = try await URLSession.shared.download(
                from: URL(string: "https://httpbin.org/get")!
            )
            debugPrint(result)
        } catch {
            print("Deu bosta: \(error)")
        }
        print("Apos finalizar a requisição.")
    }
    
    static func run03() async {
        let countToTen = DispatchQueue(label: "count_to_ten")
        let countToTwenty = DispatchQueue(label: "count_from_ten_to_twenty")
        
        /// assincrono
        countToTen.async {
            for i in 0...10 {
                print(i)
            }
        }
        
        /// sincrono
        countToTwenty.sync {
            for i in 11...20 {
                print(i)
            }
        }
        
        /// Grand Central Dispatch e uma API de baixo nivel que ajuda a lidar com concorrencia.
        /// Volta a tarefa para a thread principal, qualquer modificação na UI tem que ser feita na thread principal
        /// Mesma coisa: DispatchQueue.global(qos: .userInteractive).async { ... }
        DispatchQueue.main.async {
            print("Estou na thread main (SERIAL)")
        }
    }
    
    static func run04() async {
        /// Higher Priority
        /// Mesma coisa: DispatchQueue.main
        DispatchQueue.global(qos: .userInteractive).async {
            print("userInteractive")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            print("userInitiated")
            DispatchQueue.main.async {
                print("voltando a thread principal")
            }
        }
        /// Mesma coisa: DispatchQueue.global()
        DispatchQueue.global(qos: .default).async {
            print("default")
        }
        /// Usado para economizar energia
        DispatchQueue.global(qos: .utility).async {
            print("utility")
        }
        /// IO Throttle
        DispatchQueue.global(qos: .background).async {
            print("background")
        }
        /// Usado como interface para API legadas
        DispatchQueue.global(qos: .unspecified).async {
            print("unspecified")
        }
        /// Lower priority
    }
}
