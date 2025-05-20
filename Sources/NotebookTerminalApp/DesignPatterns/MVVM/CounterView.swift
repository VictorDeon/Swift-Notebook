import SwiftUI

/// View (ContentView): observa o ViewModel via @StateObject e atualiza a UI.
struct CounterView: View {
    
    @StateObject private var viewModel = CounterViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.valueText)
                .font(.largeTitle)

            Button("Increment") {
                viewModel.increment()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .frame(width: 300, height: 300, alignment: .center)
    }
}
