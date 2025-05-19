//  Deve ativar o bleep (delegate) remotamente, fazendo um barulho e notificando a pessoa responsavel
//  por resolver a emergencia.

class EmergencyCallHandler {
    var delegate: AdvancedLifeSupportProtocol?

    func assessSituation() {
        print("Pode me dizer o que aconteceu?")
    }

    func medicalEmergency() {
        delegate?.performCPR()
    }
}
