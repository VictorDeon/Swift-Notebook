// Tutorial em Swift cobrindo três pilares de segurança em aplicações iOS/macOS:
// criptografia simétrica, criptografia assimétrica (assinatura digital e acordo de chave)
// e geração/validação de tokens JWT.
// Armazenamento seguro de chaves: Use o Keychain ou Secure Enclave no iOS/macOS para guardar
// chaves simétricas e privadas. O Secure Enclave é um co-processador de segurança no dispositivo que
// impede a extração da chave privada.
// Rotação de chaves: Implemente políticas para trocar chaves periodicamente.
// Proteção de código e dados em trânsito: Sempre negocie TLS para canais de rede.
// Validação de payloads JWT: Verifique exp, nbf e campos custom antes de autorizar ações.

import Foundation
import ArgumentParser
import CryptoKit
import SwiftJWT

struct CriptografyCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "criptografy",
        abstract: "Tutorial sobre criptografia em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Criptografia Simétrica (AES-GCM):")
        CriptografiaSimetrica.run()
        print("→ [Criptografia Assimétrica] Assinatura Digital com P256 (ECDSA):")
        CriptografiaAssimetrica.assinaturaDigital()
        print("→ [Criptografia Assimétrica] Acordo de Chave (ECDH) com Curve25519:")
        CriptografiaAssimetrica.acordoDeChave()
        print("→ Token JWT")
        let token = TokensJWT.encode()
        TokensJWT.decode(signedJWT: token)
    }
}

/// Criptografia Simétrica (AES-GCM)
/// Na criptografia simétrica, usamos a mesma chave para encriptar e decriptar.
/// AES-GCM: fornece confidencialidade e autenticação (integridade e não rejeição).
/// O sealedBox.combined já inclui nonce e tag, facilitando armazenamento/transmissão.
struct CriptografiaSimetrica {
    static func run() {
        // 1. Gerar uma chave simétrica de 256 bits
        let key = SymmetricKey(size: .bits256)

        // 2. Texto claro
        let plaintext = "Mensagem secreta".data(using: .utf8)!

        // 3. Encriptar usando AES-GCM
        do {
            let sealedBox = try AES.GCM.seal(plaintext, using: key)
            let combined = sealedBox.combined!       // contém nonce + ciphertext + tag
            print("Ciphertext (base64):", combined.base64EncodedString())

            // 4. Decriptar
            let box = try AES.GCM.SealedBox(combined: combined)
            let decrypted = try AES.GCM.open(box, using: key)
            let decryptedText = String(data: decrypted, encoding: .utf8)!
            print("Decrypted:", decryptedText)
        } catch {
            print("Erro na criptografia simétrica:", error)
        }
    }
}

/// Criptografia Assimétrica
/// As chaves são persistido em memoria.
struct CriptografiaAssimetrica {
    /// 2.1. Assinatura Digital com P256 (ECDSA)
    /// Usada para garantir integridade e autoria de mensagens.
    static func assinaturaDigital() {
        // 1. Gerar par de chaves P256
        let privateKey = P256.Signing.PrivateKey()
        let publicKey = privateKey.publicKey

        // 2. Mensagem a assinar
        let message = "Dados importantes".data(using: .utf8)!

        // 3. Assinar
        let signature = try? privateKey.signature(for: message)
        print("Signature (DER, base64):", signature!.derRepresentation.base64EncodedString())

        // 4. Verificar assinatura
        let isValid = publicKey.isValidSignature(signature!, for: message)
        print("Assinatura válida?", isValid)
    }

    /// Acordo de Chave (ECDH) com Curve25519
    static func acordoDeChave() {
        // MARK: – 1. Geração das chaves de Alice e Bob
        // Alice gera seu par de chaves Curve25519
        let alicePrivateKey = Curve25519.KeyAgreement.PrivateKey()
        let alicePublicKeyData = alicePrivateKey.publicKey.rawRepresentation

        // Bob gera seu par de chaves Curve25519
        let bobPrivateKey = Curve25519.KeyAgreement.PrivateKey()
        let bobPublicKeyData = bobPrivateKey.publicKey.rawRepresentation

        // Em um sistema real, Alice e Bob trocariam `alicePublicKeyData` e `bobPublicKeyData` via canal seguro.

        // MARK: – 2. Derivação da chave simétrica compartilhada
        func deriveSharedSymmetricKey(
            myPrivateKey: Curve25519.KeyAgreement.PrivateKey,
            peerPublicKeyData: Data
        ) throws -> SymmetricKey {
            let peerPublicKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: peerPublicKeyData)
            let sharedSecret = try myPrivateKey.sharedSecretFromKeyAgreement(with: peerPublicKey)
            // Deriva uma chave AES-256 a partir do segredo compartilhado
            return sharedSecret.hkdfDerivedSymmetricKey(
                using: SHA256.self,
                salt: "RocketmanTechSalt".data(using: .utf8)!,
                sharedInfo: Data(),  // você pode incluir metadados aqui
                outputByteCount: 32
            )
        }

        // Alice e Bob derivam a mesma chave simétrica
        let aliceSymKey = try? deriveSharedSymmetricKey(
            myPrivateKey: alicePrivateKey,
            peerPublicKeyData: bobPublicKeyData
        )

        let bobSymKey = try? deriveSharedSymmetricKey(
            myPrivateKey: bobPrivateKey,
            peerPublicKeyData: alicePublicKeyData
        )

        // Verificação (para fins de debug; remova em produção)
        assert(aliceSymKey! == bobSymKey!, "As chaves simétricas devem ser iguais!")

        // MARK: – 3. Alice encripta uma mensagem para Bob
        func encryptMessage(_ message: String, using key: SymmetricKey) throws -> Data {
            let plaintext = message.data(using: .utf8)!
            let sealed = try AES.GCM.seal(plaintext, using: key)
            // Retornamos nonce + ciphertext + tag concatenados
            return sealed.combined!
        }

        let mensagemDaAlice = "Olá Bob, esta é uma mensagem segura!"
        let ciphertext = try? encryptMessage(mensagemDaAlice, using: aliceSymKey!)
        print("Ciphertext (base64):", ciphertext!.base64EncodedString())

        // MARK: – 4. Bob decripta a mensagem
        func decryptMessage(_ combinedData: Data, using key: SymmetricKey) throws -> String {
            let sealedBox = try AES.GCM.SealedBox(combined: combinedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)!
        }

        let mensagemDeBob = try? decryptMessage(ciphertext!, using: bobSymKey!)
        print("Bob leu:", mensagemDeBob!)
    }
}

struct MyClaims: Claims {
    let sub: String      // subject (usuário)
    let exp: Date        // expiração
    let roles: [String]  // custom claim
}

/// JSON Web Tokens são largamente usados para autenticação/autorização.
struct TokensJWT {
    static let secret: String = "segredo-super-secreto"

    static func encode() -> String {
        // 2. Header + Claims
        var jwt = JWT(header: Header(kid: "meuKeyID"), claims: MyClaims(
            sub: "user123",
            exp: Date(timeIntervalSinceNow: 3600),
            roles: ["admin", "user"]
        ))

        // 3. Chave de assinatura (exemplo HMAC com segredo)
        let secret = self.secret.data(using: .utf8)!
        let signer = JWTSigner.hs256(key: secret)

        // 4. Assinar
        let signedJWT = try? jwt.sign(using: signer)
        print("JWT:", signedJWT!)

        return signedJWT!
    }

    static func decode(signedJWT: String) {
        // 5. Verificação
        let secret = self.secret.data(using: .utf8)!
        let verifier = JWTVerifier.hs256(key: secret)
        do {
            let receivedJWT = try JWT<MyClaims>(jwtString: signedJWT, verifier: verifier)
            print("Claims:", receivedJWT.claims)
        } catch {
            print("Falha ao verificar JWT:", error)
        }
    }
}
