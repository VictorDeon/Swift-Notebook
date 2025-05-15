// Aqui vamos mostrar como utiliza os logs do swift

import Foundation
import AppKit
import ArgumentParser
import Logging

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

    mutating func run() async throws -> Void {
        await MainActor.run {
            print("Oi eu sou o print!")

            let traceID = UUID().uuidString
            let logger = LoggerSingleton.shared

            logger.debug("Msg")
            // 2025-05-15 18:51:14 [debug] vX.Y.Z: Msg
            logger.debug("Msg + trace", trace: traceID)
            // 2025-05-15 18:51:14 [debug] vX.Y.Z trace=19CC049E-FECD-4E62-AC6C-354CB0786687: Msg + trace
            logger.debug("Msg + trace + json", trace: traceID, json: [
                "userId": AnyEncodable("fulano@gmail.com"),
                "retry": AnyEncodable(false)
            ])
            // 2025-05-15 18:51:14 [debug] vX.Y.Z trace=19CC049E-FECD-4E62-AC6C-354CB0786687: Msg + trace + json {"retry":false,"userId":"fulano@gmail.com"}

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
                // 2025-05-15 18:51:14 [error] vX.Y.Z: Erro: tentativa de divisão por zero.
                logger.error(error)
                // 2025-05-15 18:51:14 [error] vX.Y.Z trace=19CC049E-FECD-4E62-AC6C-354CB0786687: Erro: tentativa de divisão por zero.
                logger.error(error, trace: traceID)
            }
            
        }
    }
}

struct SimpleLogHandler: LogHandler {
    let label: String
    var metadata: Logger.Metadata = [:]
    var logLevel: Logger.Level = .debug

    private let dateFormatter: DateFormatter = {
      let f = DateFormatter()
      f.dateFormat = "YYY-MM-dd HH:mm:ss"
      return f
    }()

    init(label: String, level: Logger.Level) {
        self.label = label
        self.logLevel = level
    }

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    func log(
      level: Logger.Level,
      message: Logger.Message,
      metadata: Logger.Metadata?,
      source: String,
      file: String,
      function: String,
      line: UInt
    ) {
        let timestamp = dateFormatter.string(from: Date())
        var msg = "\(timestamp) [\(level)]"
        if let version = metadata!["version"] {
            msg += " \(version)"
        }

        if let trace = metadata!["trace"] {
            msg += " trace=\(trace)"
        }
        
        print(msg + ": \(message)")
    }
}

/// AnyEncodable para embrulhar vários tipos em um Encodable genérico
public struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    public init<T: Encodable>(_ wrapped: T) {
        encodeClosure = wrapped.encode(to:)
    }

    public func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}

/// JSONFormatter que usa JSONEncoder configurado para ISO8601, sem escapar barras, etc.
public struct JSONFormatter {
    private let encoder: JSONEncoder

    public init() {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        // Se quiser saída compacta:
        encoder.outputFormatting = []
    }

    public func stringify(_ dict: [String: AnyEncodable]) -> String {
        do {
            let data = try encoder.encode(dict)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return "{\"encoding_error\": \"\(error)\"}"
        }
    }
}

@MainActor
public final class LoggerSingleton {
    public static let shared = LoggerSingleton()
    private let logger: Logger
    private let jsonFormatter = JSONFormatter()
    private let version = "vX.Y.Z"

    private init() {
        let lvlStr = ProcessInfo.processInfo.environment["LOG_LEVEL"] ?? "info"
        let level: Logger.Level = {
            switch lvlStr.uppercased() {
                case "INFO":     return .info
                case "WARNING":  return .warning
                case "ERROR":    return .error
                default:         return .debug
            }
        }()

        LoggingSystem.bootstrap { label in
            return SimpleLogHandler(label: label, level: level)
        }

        self.logger = Logger(label: "tech.rocketman.nts")
    }

    // MARK: Métodos de logging
    public func debug(_ msg: String, trace: String?, json: [String: AnyEncodable]?) {
        var metadata: [String: Logger.MetadataValue] = ["version": .string(version)]
        if let traceSafe = trace {
            metadata["trace"] = .string(traceSafe)
        }

        if let jsonSafe = json {
            let payload = jsonFormatter.stringify(jsonSafe)
            logger.debug("\(msg) \(payload)", metadata: metadata)
            return
        }
        logger.debug("\(msg)", metadata: metadata)
    }
    
    public func debug(_ msg: String, trace: String) {
        self.debug(msg, trace: trace, json: nil)
    }
    
    public func debug(_ msg: String) {
        self.debug(msg, trace: nil, json: nil)
    }

    public func info(_ msg: String, trace: String?, json: [String: AnyEncodable]?) {
        var metadata: [String: Logger.MetadataValue] = ["version": .string(version)]
        if let traceSafe = trace {
            metadata["trace"] = .string(traceSafe)
        }

        if let jsonSafe = json {
            let payload = jsonFormatter.stringify(jsonSafe)
            logger.info("\(msg) \(payload)", metadata: metadata)
            return
        }
        logger.info("\(msg)", metadata: metadata)
    }
    
    public func info(_ msg: String, trace: String) {
        self.info(msg, trace: trace, json: nil)
    }
    
    public func info(_ msg: String) {
        self.info(msg, trace: nil, json: nil)
    }

    public func warning(_ msg: String, trace: String?, json: [String: AnyEncodable]?) {
        var metadata: [String: Logger.MetadataValue] = ["version": .string(version)]
        if let traceSafe = trace {
            metadata["trace"] = .string(traceSafe)
        }

        if let jsonSafe = json {
            let payload = jsonFormatter.stringify(jsonSafe)
            logger.warning("\(msg) \(payload)", metadata: metadata)
            return
        }
        logger.warning("\(msg)", metadata: metadata)
    }
    
    public func warning(_ msg: String, trace: String) {
        self.warning(msg, trace: trace, json: nil)
    }
    
    public func warning(_ msg: String) {
        self.warning(msg, trace: nil, json: nil)
    }

    public func error(_ error: Error, trace: String?) {
        var metadata: [String: Logger.MetadataValue] = ["version": .string(version)]
        if let traceSafe = trace {
            metadata["trace"] = .string(traceSafe)
        }
        logger.error("\(error.localizedDescription)", metadata: metadata)
    }

    public func error(_ error: Error) {
        self.error(error, trace: nil)
    }
}
