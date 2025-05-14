// Usado para armazenar dados sensiveis de forma segura.
// 1. O helper lida somente com dados binários (Data). Se precisar salvar structs/objetos,
// você pode codificá-los em JSON via JSONEncoder antes de chamar save, e decodificá-los ao ler.
// 2. Para dados mais sensíveis, considere usar atributos de acessibilidade
// (por exemplo, kSecAttrAccessibleWhenUnlockedThisDeviceOnly) no dicionário de query,
// garantindo que o valor só seja acessível quando o dispositivo estiver destravado.
// 3. Se for importante proteger com biometria, você pode usar kSecUseAuthenticationUI
// e kSecAccessControl para exigir Touch ID/Face ID na leitura.

import AppKit
import ArgumentParser
import Security

struct KeyChainCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "keychain",
        abstract: "Tutorial sobre keychain store em swift"
    )

    @OptionGroup var common: CommonOptions
    
    @Option(
        name: .long,  // --service
        help: "O identificador unico do serviço (e.g., bundle ID)"
    )
    var service: String = "tech.vksoftware.example"
    
    @Option(
        name: [.customLong("key")],  // --key
        help: "A chave na qual o dados será armazenado"
    )
    var account: String
    
    @Option(
        name: .long,  // --data
        help: "Os dados sensiveis que serão armazenados."
    )
    var data: String

    mutating func run() async throws -> Void {
        await MainActor.run {
            keychainRunner(service, account, data)
        }
    }
}

@MainActor
final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    /// Salva dados no Keychain
    /// - Parameters:
    ///   - service: Identifica o “serviço” (normalmente, seu bundle ID).
    ///   - account: Chave dentro do serviço
    ///   - data: Os bytes a serem armazenados.
    func save(service: String, account: String, data: Data) -> Bool {
        // First, delete existing item if present
        _ = delete(service: service, account: account)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // classe generica de senha
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        // Adiciona o item ao keychain e retorna o status
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Ler os dados do KeyChain
    /// - Parameters:
    ///   - service: Identifica o “serviço” (normalmente, seu bundle ID).
    ///   - account: Chave dentro do serviço
    /// - Returns: Os dados armazenados na chave ou Nil caso não encontre.
    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,  // Pede que o Keychain devolva o campo de dados.
            kSecMatchLimit as String: kSecMatchLimitOne  // Só queremos um resultado (o primeiro que bater).
        ]

        var result: AnyObject?
        // Busca o item; preenche result com o CFData armazenado.
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    /// Atualiza os dados de uma chave do keychain
    /// - Parameters:
    ///   - service: Identifica o “serviço” (normalmente, seu bundle ID).
    ///   - account: Chave dentro do serviço
    ///   - data: Novos dados
    func update(service: String, account: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        // Aplica a modificação.
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        return status == errSecSuccess
    }

    /// Deleta um item do keychain
    /// - Parameters:
    ///   - service: Identifica o “serviço” (normalmente, seu bundle ID).
    ///   - account: Chave dentro do serviço
    func delete(service: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        // Deleta o item e retorna o status
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}


@MainActor
func keychainRunner(_ serviceBundle: String, _ account: String, _ data: String) {
    let service = Bundle.main.bundleIdentifier ?? serviceBundle

    if let tokenData = data.data(using: .utf8) {
        // Create or overwrite
        _ = KeychainHelper.shared.save(service: service, account: account, data: tokenData)
        print("Chave \(account) criada com sucesso no keychain")

        // Read
        if let retrieved = KeychainHelper.shared.read(service: service, account: account),
           let retrievedString = String(data: retrieved, encoding: .utf8) {
            print("Recuperado do Keychain: \(retrievedString)")
        }

        // Update
        let newToken = "def456"
        if let newData = newToken.data(using: .utf8) {
            _ = KeychainHelper.shared.update(service: service, account: account, data: newData)
            print("Novo dado atualizado com sucesso no keychain")
        }
        
        // Read
        if let retrieved = KeychainHelper.shared.read(service: service, account: account),
           let retrievedString = String(data: retrieved, encoding: .utf8) {
            print("Recuperado do Keychain: \(retrievedString)")
        }

        // Delete
        _ = KeychainHelper.shared.delete(service: service, account: account)
        print("Chave deletada do keychain com sucesso.")
    }

}


