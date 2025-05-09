// Pessoa que tem o certificado/protocolo para poder realizar o CPR e esta segurando o bleep (delegate)
struct Paramedic: AdvancedLifeSupportProtocol {
    init(handler: EmergencyCallHandler) {
        handler.delegate = self
    }
    
    func performCPR() {
        print("O paramédico fez uma compressa por 30 segundos.")
    }
}
