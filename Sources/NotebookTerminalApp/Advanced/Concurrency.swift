// Concorrencia é a habilidade de rodar multiplos códigos ao mesmo tempo.
// A interface do usuário é executada na thread principal (main thread) enquanto outras tarefas de IO
// bound é executada em background tasks e quando precisa atualizar algo na UI, temos que retornar a main thread.
// As tasks são organizadas em Queue dentro das threads para ser processadas pelo CPU

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
}
