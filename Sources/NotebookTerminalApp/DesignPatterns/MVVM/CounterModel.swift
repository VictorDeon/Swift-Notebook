import Foundation

/// Estrutura simples que armazena o estado
struct Counter: Identifiable {
    let id: UUID = UUID()
    var value: Int = 0
}
