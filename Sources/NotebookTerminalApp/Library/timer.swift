// Estudando a lib Timer

import Foundation
import AppKit
import ArgumentParser

struct TimeCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "timer",
        abstract: "Tutorial sobre timer em swift"
    )

    @OptionGroup var common: CommonOptions
    
    @Flag(
        name: .customLong("async"),  // --async
        help: "Executa usando código assincrono."
    )
    var executeAsync: Bool = false

    func run() throws {
        if executeAsync {
            print("Iniciando o timer assincrono.")
            timerRunnerAsync()
        } else {
            print("Iniciando o timer sincrono.")
            timerRunnerSync()
        }
    }
}

class Logo {
    var title: String = ""
    private var delay: Double = 0.0
    
    func addChar(_ char: Character) {
        self.delay += 1.0
        Timer.scheduledTimer(withTimeInterval: 0.1 * delay, repeats: false) { _ in
            self.title.append(char)
            print(self.title)
            // F
            // Fl
            // Fla
            // Flas
            // Flash
            // FlashC
            // FlashCh
            // FlashCha
            // FlashChat
        }
    }
    
    func closeTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.2 * delay, repeats: false) { _ in
            // Encerra o RunLoop se estiver em CLI um pouco depois de o time acima executar
             CFRunLoopStop(CFRunLoopGetMain())
        }
    }
}
extension Logo: @unchecked Sendable {}

func timerRunnerSync() {
    let logo = Logo()
    let title = "FlashChat"
    for letter in title {
        logo.addChar(letter)
    }
    logo.closeTimer()

    // Em aplicações de linha de comando você precisa rodar o loop:
    CFRunLoopRun()
    print("Titulo: \(logo.title)")  // Titulo: FlashChat
}

func timerRunnerAsync() {
    let title = "FlashChat"
    var current = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    for (index, char) in title.enumerated() {
        // espera 0.1s * (index+1)
        let delay = UInt64(0.1 * Double(index + 1) * 1_000_000_000)
        Task {
            try? await Task.sleep(nanoseconds: delay)
            semaphore.signal()
        }
        
        semaphore.wait()

        current.append(char)
        print(current)
    }
    
    print("Título completo: \(current)")
}
