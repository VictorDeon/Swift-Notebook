import SwiftUI
import ArgumentParser
import VKSwiftUI

struct ListCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalSwiftUI.showWindow(StringListContentView(), by: app, title: "String")
            app.run()
            
            TerminalSwiftUI.showWindow(ItemListContentView(), by: app, title: "Items")
            app.run()
            
            TerminalSwiftUI.showWindow(ForListContentView(), by: app, title: "ForEach")
            app.run()
            
            TerminalSwiftUI.showWindow(ScrollListContentView(), by: app, title: "Scroll")
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct StringListContentView: View {
    
    @State private var shoppingItems: [String] = [
        "Apples",
        "Bananas",
        "Oranges",
        "Pears"
    ]

    var body: some View {
        VStack(spacing: 15) {
            List(shoppingItems, id: \.self) { item in
                Text(item)
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct ShoppingModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let price: Double
}

fileprivate struct ItemListContentView: View {
    
    @State private var shoppingItems: [ShoppingModel] = [
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40)
    ]

    var body: some View {
        VStack(spacing: 15) {
            List(shoppingItems) { item in
                HStack {
                    Text(item.title)
                    Spacer()
                    Text("$\(String(format: "%.2f", item.price))")
                }
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct ForListContentView: View {
    
    @State private var shoppingItems: [ShoppingModel] = [
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40)
    ]

    var body: some View {
        VStack(spacing: 15) {
            List {
                ForEach(shoppingItems) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        Text("$\(String(format: "%.2f", item.price))")
                    }
                }
                Text("Finalizou a Lista!!")
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

/// O List por padrão já é um ScrollView
fileprivate struct ScrollListContentView: View {
    
    @State private var shoppingItems: [ShoppingModel] = [
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
        ShoppingModel(title: "Apples", price: 12.30),
        ShoppingModel(title: "Bananas", price: 11.32),
        ShoppingModel(title: "Oranges", price: 9.40),
        ShoppingModel(title: "Pears", price: 33.40),
    ]

    var body: some View {
        ScrollView(.vertical) {
            ForEach(shoppingItems) { item in
                HStack {
                    Text(item.title)
                    Spacer()
                    Text("$\(String(format: "%.2f", item.price))")
                }
            }
            Text("Finalizou a Lista!!")
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}
