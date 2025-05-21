// Tutorial sobre execução de comandos do sistema operacional macos
// Evite strings concatenadas: use sempre arguments para não enfrentar problemas com espaços ou caracteres especiais.
// Use /usr/bin/env quando não souber o caminho exato do binário.
// Trate timeouts: se precisar, crie um timer para chamar process.terminate().
// Segurança: cuidado ao executar comandos construídos a partir de input do usuário – evite injeção de comandos.
// Logging: registre stdout e stderr em logs separados para facilitar debugging.

import Foundation
import AppKit
import ArgumentParser
import Dispatch

struct SOCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "so",
        abstract: "Tutorial sobre sistema operacional em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Execução assincrona:")
        AsyncExecution.run()
        print("→ Conceitos Basicos:")
        ConceitosBasicos.run()
        print("→ Tratando Erros de Forma Robusta:")
        TratandoErrorDeFormaRobusta.run()
        print("→ Rodando qualquer comando no terminal:")
        do {
            let result = try runShellCommand("/usr/bin/env", ["git", "--version"])
            print("Git: \(result.output.trimmingCharacters(in: .whitespacesAndNewlines))")
            print("Status: \(result.exitCode)")
        } catch {
            print("Erro geral: \(error)")
        }
    }
}

/// Em Swift (em macOS/iOS ou Linux), a classe principal para executar comandos externos é a Process.
/// Para capturar a saída (stdout e stderr), usamos a classe Pipe.
fileprivate struct ConceitosBasicos {
    static func run() {
        let process = Process()
        // caminho do executável
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        // lista de argumentos que você passaria no terminal.
        process.arguments = ["ls", "-la", "/"]
        // redirecionam a saída padrão e erros para um Pipe.
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        // Executando Sincronamente e Capturando Resultado
        do {
            // Inicia o processo
            try process.run()
            // bloqueia até o término.
            process.waitUntilExit()

            // lê tudo que foi escrito no pipe.
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                print("Saída do comando:\n\(output)")
            }

            // retorna o código de saída (0 = sucesso)
            let status = process.terminationStatus
            print("Código de saída: \(status)")
        } catch {
            print("Falha ao executar o processo: \(error)")
        }
    }
}

/// Para diferenciar stdout de stderr, use pipes separados, assim é possível tratar mensagens de erro separadamente.
fileprivate struct TratandoErrorDeFormaRobusta {
    static func run() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["ls", "-la", "/"]

        // Passando Variáveis de Ambiente para o processo
        process.environment = [
            "PATH": "/usr/local/bin:/usr/bin:/bin",
            "MY_VAR": "valor_exemplo"
        ]

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        try? process.run()
        process.waitUntilExit()

        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

        let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
        let stderr = String(data: stderrData, encoding: .utf8) ?? ""

        print("✅ Saída:\n\(stdout)")
        print("❌ Erros:\n\(stderr)")
    }
}

/// Execução Assíncrona para não bloquear a thread principal (útil em apps GUI ou servidores)
fileprivate struct AsyncExecution {
    static func run() {
        let queue = DispatchQueue(label: "tech.vksoftware.process", qos: .userInitiated)

        queue.async {
            do {
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
                process.arguments = ["ls", "-la", "/"]

                let stdoutPipe = Pipe()
                let stderrPipe = Pipe()
                process.standardOutput = stdoutPipe
                process.standardError = stderrPipe

                try process.run()

                // terminationHandler é chamado quando o processo termina.
                process.terminationHandler = { proc in
                    let outData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
                    let errData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

                    let out = String(data: outData, encoding: .utf8) ?? ""
                    let err = String(data: errData, encoding: .utf8) ?? ""

                    print("[ASYNC] Processo finalizado com código \(proc.terminationStatus)")
                    print("[ASYNC] Saída:\n\(out)")
                    print("[ASYNC] Erros:\n\(err)")
                }
            } catch {
                print("[ASYNC] Erro ao iniciar processo: \(error)")
            }
        }

        // A thread principal continua livre, ou seja, continua executando outras tarefas...
        print("Chamou o comando de forma assíncrona.")
    }
}

/// Rode qualquer comando shell
fileprivate func runShellCommand(_ launchPath: String, _ arguments: [String]) throws -> (output: String, exitCode: Int32) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: launchPath)
    process.arguments = arguments

    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()
    process.standardOutput = stdoutPipe
    process.standardError = stderrPipe

    try process.run()
    process.waitUntilExit()

    let outData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
    let errData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

    let output = String(data: outData + errData, encoding: .utf8) ?? ""
    let status = process.terminationStatus

    return (output, status)
}
