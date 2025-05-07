// Pessoa que tem o certificado/protocolo para poder realizar o CPR e esta segurando o bleep (delegate)

class Surgeon: Doctor {
    override func performCPR() {
        super.performCPR()
        print("Estou cantando 'Staying Alive' para manter o paciente vivo.")
    }
    
    func useElectricDrill() {
        print("Whirr...")
    }
}
