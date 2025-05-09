// Pessoa que tem o certificado/protocolo para poder realizar o CPR e esta segurando o bleep (delegate)
class Doctor: AdvancedLifeSupportProtocol {
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("O médico fez uma compressa por 30 segundos.")
    }
    
    func useStethescope() {
        print("Escutando o coração do paciente.")
    }
}
