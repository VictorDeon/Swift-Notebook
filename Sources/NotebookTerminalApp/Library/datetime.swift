// Manipulação de data e hora

import AppKit
import ArgumentParser

struct DateTimeCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "datetime",
        abstract: "Tutorial sobre datetime em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Criando instâncias de Date")
        InstanciasDate.run()
        print("→ Formatando datas com DateFormatter")
        FormatandoDatas.run()
        print("→ Convertendo strings em Date")
        ConverterStringEmDate.run()
        print("→ Trabalhando com Calendar e DateComponents")
        CalendarEDataComponents.run()
        print("→ Intervalos e comparação de datas")
        IntervalosEComparacao.run()
        print("→ Time zones e Locale")
        TimeZonesELocale.run()
        print("→ Medindo duração de operações")
        MedindoDuracao.run()
        print("→ Formatos padronizados - ISO 8601")
        FormatosPadronizados.run()
    }
}

/// Criando instâncias de Date
struct InstanciasDate {
    static func run() {
        // Data e hora atual
        let now = Date()
        print(now)  // 2025-05-16 18:28:13 +0000

        // Data específica (usando TimeInterval desde 1970-01-01 00:00:00 UTC)
        let temp: TimeInterval = 1_600_000_000
        let specificDate = Date(timeIntervalSince1970: temp)
        print(specificDate)  // 2020-09-13 12:26:40 +0000

        // Data relativa (por exemplo, 1 dia à frente)
        let oneDay: TimeInterval = 24 * 60 * 60
        let tomorrow = now.addingTimeInterval(oneDay)
        print(tomorrow)  // 2025-05-17 18:28:13 +0000
    }
}

/// Formatando datas com DateFormatter
/// Dicas de dateFormat:
///     yyyy – ano completo
///     MM – mês (01–12)
///     dd – dia do mês (01–31)
///     HH – hora em 24h (00–23)
///     mm – minuto (00–59)
///     ss – segundo (00–59)
struct FormatandoDatas {
    static func run() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        // formatter.dateStyle = .short    // 16/05/25
        // formatter.timeStyle = .medium   // 14:30:15

        let text = formatter.string(from: now)
        print(text)  // → "16/05/2025 15:31:22"
    }
}

/// Convertendo strings em Date
struct ConverterStringEmDate {
    static func run() {
        let dateString = "2025-05-20 09:45"
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "pt_BR")
        parser.timeZone = TimeZone(abbreviation: "UTC")
        parser.dateFormat = "yyyy-MM-dd HH:mm"

        if let covertedDate = parser.date(from: dateString) {
            print(covertedDate)  // 2025-05-20 09:45:00 +0000
        } else {
            print("Formato inválido")
        }
    }
}

/// Trabalhando com Calendar e DateComponents
/// O Calendar permite extrair componentes (ano, mês, dia…) e fazer cálculos.
struct CalendarEDataComponents {
    static func run() {
        let now = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
        print("Ano: \(dateComponents.year!), Mês: \(dateComponents.month!), Dia: \(dateComponents.day!)")
        // Ano: 2025, Mês: 5, Dia: 16

        // Adicionando 2 meses e 10 dias
        var toAddComponent = DateComponents()
        toAddComponent.year = 1
        toAddComponent.month = 2
        toAddComponent.day = 10

        if let futureDate = calendar.date(byAdding: toAddComponent, to: now) {
            print("Nova data: \(futureDate)") // Nova data: 2026-07-26 18:44:45 +0000
        }
    }
}

/// Intervalos e comparação de datas
struct IntervalosEComparacao {
    static func run() {
        let today = Date()
        let oneDay: TimeInterval = 24 * 60 * 60
        let tomorrow = today.addingTimeInterval(oneDay)
        
        // Comparações
        if today < tomorrow {
            print("Hoje vem antes de Amanha")
            // Hoje vem antes de Amanha
        }

        // Intervalo em segundos
        let secondsInterval = tomorrow.timeIntervalSince(today)
        print("De Hoje até amanha tem \(secondsInterval) segundos.")
        // De Hoje até amanha tem 86400.0 segundos.

        // Usando DateInterval para representar um período
        let interval = DateInterval(start: today, end: tomorrow)
        print("Duração em horas: \(interval.duration / 3600)")
        // Duração em horas: 24.0
    }
}

/// Time zones e Locale
struct TimeZonesELocale {
    static func run() {
        let today = Date()

        // Listar fusos disponíveis
        let fusos = TimeZone.knownTimeZoneIdentifiers
        print(fusos.prefix(5))
        // ["Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara"]

        // Converter data entre fusos
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm zzz"
        df.locale = Locale(identifier: "pt_BR")
        
        df.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        print("Brasil SP: \(df.string(from: today))")
        // Brasil SP: 2025-05-16 15:51 BRT

        df.timeZone = TimeZone(identifier: "America/New_York")
        print("NY: \(df.string(from: today))")
        // NY: 2025-05-16 14:49 GMT-4

        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        print("Tokyo: \(df.string(from: today))")
        // Tokyo: 2025-05-17 03:49 GMT+9
        
        df.timeZone = TimeZone(identifier: "UTC")
        print("UTC: \(df.string(from: today))")
        // UTC: 2025-05-16 18:49 GMT
    }
}

/// Medindo duração de operações
/// Para medições de performance mais precisas, prefira DispatchTime ou CFAbsoluteTimeGetCurrent().
struct MedindoDuracao {
    static func run() {
        let start = Date()
        sleep(3)
        let end = Date()
        let duration = end.timeIntervalSince(start)
        print("A operação levou \(String(format: "%.2f", duration)) segundos")
    }
}

/// Formatos padronizados
struct FormatosPadronizados {
    static func run() {
        let today = Date()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let isoString = isoFormatter.string(from: today)
        print(isoString) // Ex.: "2025-05-16T14:30:00Z"
    }
}
