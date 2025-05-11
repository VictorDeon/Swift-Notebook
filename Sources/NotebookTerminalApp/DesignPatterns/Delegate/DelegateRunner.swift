/*
    Vamos fazer o exemplo de um call center emergencial que é responsável por responser a chamadas emergencias
    e redirecionar para o local correto.
 */

import AppKit

func delegateRunner() {
    let emilio = EmergencyCallHandler()
    // Pegou o bleep e ficou por um tempo depois passou para a angela
    let peter = Paramedic(handler: emilio)
    // angela esta com o bleep agora e vai responder a qualquer emergencia medica
    let angela = Surgeon(handler: emilio)

    emilio.assessSituation()
    // Pode me dizer o que aconteceu?
    emilio.medicalEmergency()
    // O médico fez uma compressa por 30 segundos.
    // Estou cantando 'Staying Alive' para manter o paciente vivo.
}
