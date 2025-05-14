// Tutorial de requisições http com Alamofire

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


