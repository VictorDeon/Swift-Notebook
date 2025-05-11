/*
    Vamos fazer o exemplo de um call center emergencial que é responsável por responser a chamadas emergencias
    e redirecionar para o local correto.
 */

import AppKit
import ArgumentParser

struct DelegateCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "delegate",
        abstract: "Tutorial sobre o padrão de projeto Delegate em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        delegateRunner()
    }
}

func delegateRunner() {
    let emilio = EmergencyCallHandler()
    // Pegou o bleep e ficou por um tempo depois passou para a o Surgeon
    let _ = Paramedic(handler: emilio)
    // O Surgeon esta com o bleep agora e vai responder a qualquer emergencia medica
    let _ = Surgeon(handler: emilio)

    emilio.assessSituation()
    // Pode me dizer o que aconteceu?
    emilio.medicalEmergency()
    // O médico fez uma compressa por 30 segundos.
    // Estou cantando 'Staying Alive' para manter o paciente vivo.
}
