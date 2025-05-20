import Foundation
import Combine

/// Classe ObservableObject que expõe dados e lógica de negócio
/// ObservableObject tem a habilidade de notificar as views que há mudança nos dados observados.
class CounterViewModel: ObservableObject {
    @Published private(set) var counter = Counter()

    var valueText: String {
        "Count: \(counter.value)"
    }

    // Business logic
    func increment() {
        counter.value += 1
    }
}
