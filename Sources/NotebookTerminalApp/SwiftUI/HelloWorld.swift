// SwiftUI Hello World
import SwiftUI

struct ContentView1: View {
    var body: some View {
        Text("Ola mundo 01!")
            .padding()
            .frame(width: 300, height: 100)
    }
}

struct ContentView2: View {
    var body: some View {
        Text("Ola mundo 02!")
            .padding()
            .frame(width: 300, height: 100)
    }
}

@MainActor func swiftUIHelloWorldRunner(_ app: NSApplication) {
    showWindow(ContentView1(), title: "Janela 1")
    app.run()
    
    showWindow(ContentView2(), title: "Janela 2")
    app.run()
}
