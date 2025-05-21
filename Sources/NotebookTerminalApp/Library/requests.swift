/**
 Tutorial de requisições http com Alamofire
 Doc: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#making-requests
 Doc: https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#security
 
 Para deixar suas requisições o mais seguras possível com Alamofire, o segredo é usar pinning de certificado
 ou de chave pública, em vez de confiar só no TLS padrão. Veja como fazer isso de forma bem simples:
 
 1. Prepare seu bundle de certificados
 * Exporte o(s) certificado(s) .pem ou .cer do seu servidor (normalmente o certificado raiz ou intermediário).
 * Arraste esses arquivos para o seu “Copy Bundle Resources” no Xcode.
 
 2. Escolha o tipo de “pinning”
 * Certificate pinning (PinnedCertificatesTrustEvaluator): compara o certificado completo.
 * Public key pinning (PublicKeysTrustEvaluator): compara só a chave pública (mais flexível se o
 servidor renovar o certificado).
 
 3. Configure o ServerTrustManager
 ```swift
 import Alamofire

 // 1) Defina para quais hosts você quer aplicar pinning:
 let evaluators: [String: ServerTrustEvaluating] = [
     // certificate pinning
     "api.meuservidor.com": PinnedCertificatesTrustEvaluator(),
     // ou public key pinning
     "login.meuservidor.com": PublicKeysTrustEvaluator()
 ]

 // 2) Crie o manager com seu mapeamento:
 let serverTrustManager = ServerTrustManager(evaluators: evaluators)

 // 3) Crie sua sessão customizada:
 let session = Session(serverTrustManager: serverTrustManager)
 ```
 
 Como funciona:
 Ao chamar session.request(...), o Alamofire vai:
 1. Validar a cadeia TLS normal (URLSession)
 2. Verificar se o certificado recebido bate com um dos que você agrupou no bundle (ou se a chave
 pública bate, no caso do PublicKeysTrustEvaluator)
 3. Garantir que o “host” do desafio bate com o certificado
 
 Se algum desses passos falhar, a requisição é abortada — protegendo você de MITM.
 
 Trate casos especiais:
 1. Revogação de certificado: adicione RevocationTrustEvaluator() num CompositeTrustEvaluator
 se precisar checar CRL/OCSP.
 2. Wildcard ou lógica customizada: crie uma subclasse de ServerTrustManager e sobrescreva
 serverTrustEvaluator(forHost:).
 3. Debug/local com self-signed: no seu Info.plist, permita local networking:
    ```plist
     <key>NSAppTransportSecurity</key>
     <dict>
       <key>NSAllowsLocalNetworking</key>
       <true/>
     </dict>
    ```
 5. Nunca use no production: O DisabledTrustEvaluator só serve para DEBUG: ele ignora toda validação e deixa
 seu app vulnerável.
 
 Resumo rápido:
 1. Inclua seus .cer/.pem no bundle
 2. Escolha PinnedCertificatesTrustEvaluator ou PublicKeysTrustEvaluator
 3. Monte um ServerTrustManager e injete numa Session
 4. Faça suas requisições por session.request(...)

 Pronto! Agora o Alamofire só aceitará certificados (ou chaves) que você mesmo aprovou, protegendo suas chamadas de
 eventuais ataques MITM.
*/

import Alamofire
import Foundation
import AppKit
import ArgumentParser

struct RequestCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "requests",
        abstract: "Tutorial sobre requisições http e pacotes de terceiros em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let login = Login(email: "test@test.test", password: "testPassword")
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            _ = await MakeRequest.get()
            _ = await MakeRequest.post(login: login)
            _ = await MakeRequest.put(login: login)
            _ = await MakeRequest.delete(userId: 10)
            _ = await MakeRequest.auth()
            await MakeRequest.batch()
            _ = await MakeRequest.download()
            _ = await MakeRequest.upload()
            semaphore.signal()
        }

        // Bloqueia até signal()
        semaphore.wait()
        print("Finalizando requisição")
    }
}

fileprivate struct Login: Encodable {
    let email: String
    let password: String
}

fileprivate struct DecodableModel: Decodable {
    let url: String
    let origin: String
    let headers: [String: String]
    let json: [String: String]?
    let data: String?
}

fileprivate struct AuthModel: Decodable {
    let authenticated: Bool
    let user: String
}

fileprivate struct MakeRequest {
    /// .validate valida se o status code esta entre 200 e 300 e se o accept type ta correto.
    /// .responseDecodable(of: ModelDecodable.self) retorna os dados formatados de acordo com a modelo
    /// que implementa o protocolo Decodable
    static func get() async -> Int? {
        let result = await AF.request("https://httpbin.org/get")
            .cURLDescription { description in print(description) }
            .validate()
            .serializingDecodable(DecodableModel.self)
            .response

        print(result.metrics?.taskInterval ?? 0)
        let url = result.value?.url ?? ""
        debugPrint(url)

        return result.response?.statusCode
    }

    /// sabemos o número fica de requisições
    static func batch() async {
        let session = Session.default
        async let first = session.request("https://httpbin.org/get").serializingDecodable(DecodableModel.self).response
        async let second = session.request("https://httpbin.org/get").serializingString().response
        async let third = session.request("https://httpbin.org/get").serializingData().response

        print("Fazendo as requisições em paralelo...")
        let responses = await (first, second, third)
        print("As 3 requisições finalizaram...")
        print(responses.0.metrics?.taskInterval ?? 0)
        print(responses.1.metrics?.taskInterval ?? 0)
        print(responses.2.metrics?.taskInterval ?? 0)
    }

    static func post(login: Login) async -> Int? {
        let headers: HTTPHeaders = [
            "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
            "Accept": "application/json"
        ]

        let result = await AF.request(
            "https://httpbin.org/post",
            method: .post,
            parameters: login,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ) { urlRequest in
            urlRequest.timeoutInterval = 5
            urlRequest.allowsConstrainedNetworkAccess = false
        }.validate().serializingDecodable(DecodableModel.self).response

        let data = result.value?.json ?? [:]
        debugPrint(data)
        print(data["email"]!)

        return result.response?.statusCode
    }

    static func put(login: Login) async -> Int? {
        let headers: HTTPHeaders = [
            "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
            "Accept": "application/json"
        ]

        let result = await AF.request(
            "https://httpbin.org/put",
            method: .put,
            parameters: login,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).validate().serializingDecodable(DecodableModel.self).response

        let data = result.value?.json ?? [:]
        debugPrint(data)
        print(data["email"]!)

        return result.response?.statusCode
    }

    static func delete(userId: Int) async -> Int? {
        let headers: HTTPHeaders = [
            .authorization(username: "Username", password: "Password"),
            .accept("application/json")
        ]

        let result = await AF.request(
            "https://httpbin.org/delete",
            method: .delete,
            headers: headers
        ).validate().serializingDecodable(DecodableModel.self).response

        let data = result.value?.json ?? [:]
        debugPrint(data)

        return result.response?.statusCode
    }

    static func auth() async -> Int? {
        let user = "user"
        let password = "password"

        let credential = URLCredential(user: user, password: password, persistence: .forSession)

        let result = await AF.request("https://httpbin.org/basic-auth/\(user)/\(password)")
            .authenticate(with: credential)
            // .authenticate(username: user, password: password)
            .validate().serializingDecodable(AuthModel.self).response

        let authenticated = result.value?.authenticated ?? false
        let loggedUser = result.value?.user ?? ""
        debugPrint(authenticated)
        print(loggedUser)

        return result.response?.statusCode
    }

    static func download() async -> Int? {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("image.png")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let response = await AF.download("https://httpbin.org/image/png", to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .validate()
            .serializingData()
            .response

        print(response.fileURL!)
        return response.response?.statusCode
    }

    static func upload() async -> Int? {
        guard let fileURL = Bundle.module.url(forResource: "version", withExtension: "txt") else { return 404 }

        let result = await AF.upload(fileURL, to: "https://httpbin.org/post", method: .post)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .validate()
            .serializingDecodable(DecodableModel.self)
            .response

        return result.response?.statusCode
    }
}
