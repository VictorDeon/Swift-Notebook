// Adicionando libs externas usando o Cocoapods
// Vamos instalar e usas essa lib: https://github.com/Alamofire/Alamofire
// Doc: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#making-requests
// Instale o cocopod pelo terminal:
//      $ sudo gem install cocoapods
//      $ pod setup --verbose
// Instale todas as dependencias que o cocoapods pedir, caso precise
// Ao finalizar a instação vamos confirmar que ta tudo certo com o comando:
//      $ pod --version
// Va até o diretorio onde o arquivo .xcodeproj do seu projeto está e
// execute o comando para criar o Podfile:
//      $ pod init
// Faça a integração do Alamofire no cocopod a partir do arquivo Podfile
//      pod 'Alamofire'
// Rode o comando:
//      $ pod install
// Agora saia da sessão que vc estas do xcode e utilize o .xcworkspace para abrir uma nova sessão.
// Para saber se a lib é compativel com seu PodFile olhe o arquivo .podspec do github deles, olhe
// a versão e a platform que é compativel
// Para atualizar as libs do seu PodFile execute o comando:
//      $ pod update
// Se quiser remover alguma lib do PodFile é só remover ela do arquivo e executar o $ pod install
// Com isso vamos poder usar a lib
// Para adicionar usando o Packages do xcode é bem mais simples só adicionar as informações necessarias
// disponibilizada pela lib dentro do Package.swift e automaticamente a lib sera inserida.

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
        var status_code1: Int? = 0
        var status_code2: Int? = 0

        Task {
            status_code1 = await MakeRequest.get()
            status_code2 = await MakeRequest.post(login: login)
            semaphore.signal()
        }
        
        // Bloqueia até signal()
        semaphore.wait()
        print(status_code1!)
        print(status_code2!)
    }
}

struct Login: Encodable {
    let email: String
    let password: String
}

struct MakeRequest {
    static func get() async -> Int? {
        let getResponse = await AF.request("https://httpbin.org/get")
            .serializingData()
            .response
        
        debugPrint(getResponse)

        return getResponse.response?.statusCode
    }
    
    static func post(login: Login) async -> Int? {
        let headers: HTTPHeaders = [
            "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
            "Accept": "application/json"
        ]
        
        let postResponse = await AF.request(
            "https://httpbin.org/post",
            method: .post,
            parameters: login,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).serializingData().response

        debugPrint(postResponse)
        
        return postResponse.response?.statusCode
    }
}


