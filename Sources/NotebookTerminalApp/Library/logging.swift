// Aqui vamos mostrar como utiliza os logs do swift

import Foundation
import AppKit
import ArgumentParser
import VKLogging

struct LoggingCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "logging",
        abstract: "Tutorial sobre logging em swift"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .shortAndLong,  // -n --numerador
        help: "numerador da divisão"
    )
    var numerador: Int = 10

    @Option(
        name: .shortAndLong,  // -d --denominador
        help: "denominador da divisão"
    )
    var denominador: Int = 2

    mutating func run() async throws {
        await MainActor.run {
            print("Oi eu sou o print!")

            let traceID = UUID().uuidString
            let logger = LoggerSingleton(
                level: "debug",
                version: "v1.2.3",
                label: "tech.vksoftware.notebookswift",
                dateTimeFormat: "dd/MM/YYYY HH:mm:ss"
            )

            logger.debug("Msg")
            // 15/05/2025 18:51:14 [debug] vX.Y.Z: Msg
            logger.debug("Msg + trace", trace: traceID)
            // 15/05/2025 18:51:14 [debug] vX.Y.Z trace=19CC049E-FECD-4E62-AC6C-354CB0786687: Msg + trace
            logger.debug("Msg + trace + json", trace: traceID, json: [
                "userId": AnyEncodable("fulano@gmail.com"),
                "retry": AnyEncodable(false)
            ])
            // 15/05/2025 18:51:14 [debug] vX.Y.Z trace=19CC049E-FECD-4E62-AC6C-354CB0786687:
            // Msg + trace + json
            // > {"retry":false,"userId":"fulano@gmail.com"}

            logger.info("Msg")
            logger.info("Msg + trace", trace: traceID)
            logger.info("Msg + trace + json", trace: traceID, json: [
                "userId": AnyEncodable("fulano@gmail.com"),
                "retry": AnyEncodable(false)
            ])

            logger.warning("Msg")
            logger.warning("Msg + trace", trace: traceID)
            logger.warning("Msg + trace + json", trace: traceID, json: [
                "userId": AnyEncodable("fulano@gmail.com"),
                "retry": AnyEncodable(false)
            ])

            do {
                // metodo criado no arquivo Exceptions.swift
                let resultado = try divide(numerador, by: denominador)
                logger.info(
                    "→ Resultado: \(resultado)",
                    trace: traceID,
                    json: ["result": AnyEncodable(resultado)]
                )
            } catch {
                // 15/05/2025 18:51:14 [error] vX.Y.Z: Erro: tentativa de divisão por zero.
                logger.error(error)
                // 15/05/2025 18:51:14 [error] vX.Y.Z trace=19CC049E-FECD-4E62-AC6C-354CB0786687:
                // Erro: tentativa de divisão por zero.
                logger.error(error, trace: traceID)
            }
        }
    }
}

fileprivate func divide(_ numerador: Int, by denominador: Int) throws -> Int {
    return numerador / denominador
}
