// Manipulação de strings com regex
// Teste seus padrões em sites como [regex101.com] ou com playgounds interativos.
// Escape caracteres especiais sempre que precisar que sejam literais.
// Prefira regex nativo do Swift 5.7+ quando possível, pois oferece sintaxe mais concisa e inferência de tipos.
// Cuidado com desempenho: evite padrões “guloso demais” em textos muito grandes ou loops aninhados.
// Comente seu regex (usando x flag no NSRegularExpression ou documentação), pois padrões complexos podem ser
// difíceis de entender.

import AppKit
import ArgumentParser
import Foundation

struct RegexCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "regex",
        abstract: "Tutorial sobre regex em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Conceitos Básicos de Regex com NSRegularExpression")
        ConceitosBasicosRegex.run()
        print("→ Capturing Groups e Named Groups")
        CapturarGrupos.run()
        print("→ Regex Nativo do Swift 5.7+ (SE-0350)")
        if #available(macOS 13.0, *) {
            RegexNativo.run()
        }
    }
}

/// Literal: sequência de caracteres que devem ser encontrados “ao pé da letra”.
/// Metacaracteres: caracteres com significado especial, ex.: . (qualquer caractere), * (0 ou mais), + (1 ou mais), ? (0 ou 1), [] (conjunto), () (grupo), | (ou).
/// Escapando: para usar um metacaractere como literal, preceda com \. Em strings Swift, precisa dobrar a barra: "\\".
/// Desde versões mais antigas de Swift (e do Foundation), você usa NSRegularExpression:
/// Métodos úteis:
///     matches(in:options:range:) → [NSTextCheckingResult]
///     firstMatch(in:options:range:) → NSTextCheckingResult?
///     enumerateMatches(in:options:range:using:) → itera com closure
///     stringByReplacingMatches(in:options:range:withTemplate:) → substituição
struct ConceitosBasicosRegex {
    static func run() {
        let pattern = "\\b\\w+@\\w+\\.\\w{2,}\\b"
        // \\b: boundary, \\w+: palavra, @, domínio, .tld de 2+ caracteres
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        let text = "Contato: joao@exemplo.com ou maria@dominio.org"
        let range = NSRange(text.startIndex..<text.endIndex, in: text)

        // Encontrar todas as ocorrências
        let matches = regex.matches(in: text, options: [], range: range)
        for m in matches {
            if let range = Range(m.range, in: text) {
                print("Email encontrado: \(text[range])")
                // Email encontrado: joao@exemplo.com
                // Email encontrado: maria@dominio.org
            }
        }
    }
}

/// Capturing Groups e Named Groups
/// Para named groups, a sintaxe é (?<nome>...), mas cuidado: NSRegularExpression só aceita se
/// o flag patternOptions: .allowCommentsAndWhitespace estiver ativo, ou você pode usar regex nativo do Swift 5.7+
struct CapturarGrupos {
    static func run() {
        let pattern = "(\\d{2})/(\\d{2})/(\\d{4})"
        // Captura dia, mês e ano
        let regex = try! NSRegularExpression(pattern: pattern)
        let text = "Data: 16/05/2025"
        let nsrange = NSRange(text.startIndex..., in: text)

        if let match = regex.firstMatch(in: text, options: [], range: nsrange) {
            let dayRange  = match.range(at: 1)
            let monthRange = match.range(at: 2)
            let yearRange = match.range(at: 3)
            if let d = Range(dayRange, in: text),
               let m = Range(monthRange, in: text),
               let y = Range(yearRange, in: text) {
                print("Dia: \(text[d]), Mês: \(text[m]), Ano: \(text[y])")
                // Dia: 16, Mês: 05, Ano: 2025
            }
        }
    }
}

/// Regex Nativo do Swift 5.7+ (SE-0350)
/// A partir do Swift 5.7, há suporte a regex literais e tipos nativos:
/// firstMatch(of:), matches(of:) para achar ocorrências.
/// replacing(_:with:) para substituições:
@available(macOS 13.0, *)
struct RegexNativo {
    static func run() {
        let emailRegex = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/
        let text = "Login: user@swift.org"

        if let match = text.firstMatch(of: emailRegex) {
            print("Encontrado: \(String(match.output))")
            // Encontrado: user@swift.org
        }
        
        let dateRegex = /(?<day>\d{2})\/(?<month>\d{2})\/(?<year>\d{4})/
        let input = "Hoje é 16/05/2025."

        if let m = input.firstMatch(of: dateRegex) {
            print("Dia:", m.output.day)     // Dia: 16
            print("Mês:", m.output.month)   // Mês: 05
            print("Ano:", m.output.year)    // Ano: 2025
        }
        
        let censored = input.replacing(dateRegex, with: "_DATA_")
        print(censored) // Hoje é _DATA_.
        
        // Validação simples de telefone (formato “(XX) XXXXX-XXXX”)
        let phoneRegex = /^\(\d{2}\) \d{5}-\d{4}$/
        let valid = try? phoneRegex.wholeMatch(in: "(11) 98765-4321") != nil
        print(valid!) // true
        
        // Dividir texto por delimitadores múltiplos
        let delimiters = /[,\s;]+/  // vírgula, espaço ou ponto-e-vírgula
        let parts = "maçã, banana;laranja  pera".split(separator: delimiters)
        print(parts) // ["maçã", "banana", "laranja", "pera"]
        
        // Extração de todas as hashtags de um comentário
        let hashRegex = /#\w+/
        let comment = "Aprendendo #Swift e #Regex em #2025!"
        let tags = comment.matches(of: hashRegex).map { String($0.output) }
        print(tags) // ["#Swift", "#Regex", "#2025"]
    }
}
