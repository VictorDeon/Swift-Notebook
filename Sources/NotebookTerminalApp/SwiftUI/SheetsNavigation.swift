import SwiftUI
import ArgumentParser

struct SheetsAndNavigationCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "navigation",
        abstract: "Sheets and Navigation com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(SheetsContentView(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

/// Identifiable você precisa configurar um ID autoincremental
/// Hashable seu parametros tem que ser possivel gerar uma hash unica, o id consegue gera isso pelo metodo hash.
fileprivate struct Person: Identifiable, Hashable {
    let id = UUID()
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

fileprivate struct SheetsContentView: View {
    
    @State private var showSheet: Bool = false
    @State private var person: Person?
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    showSheet = true
                } label: {
                    Text("Boolean Sheet")
                }
                Divider()
                Button {
                    person = Person(name: "Paul")
                } label: {
                    Text("Item Sheet")
                }
                Divider()
                NavigationLink {
                    NavigationItemView(person: Person(name: "Paul"))
                } label: {
                    Text("Navigation Link Item View")
                }

                
            }
            .padding(10)
            .frame(width: 300, height: 300, alignment: .center)
            .sheet(isPresented: $showSheet, onDismiss: { print("Saindo do sheet") }) {
                SheetView(showSheet: $showSheet)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $person) { person in
                SheetItemView(person: person)
            }
        }
    }
}

fileprivate struct SheetView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var showSheet: Bool

    var body: some View {
        VStack {
            Text("Ola mundo sheet! Precione ESC ou clique nos botões abaixo para voltar.")
            Button {
                dismiss()
            } label: {
                Text("Voltar 01")
            }
            Button {
                showSheet = false
            } label: {
                Text("Voltar 02")
            }

        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct SheetItemView: View {
    
    let person: Person

    var body: some View {
        VStack {
            Text(person.name)
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

fileprivate struct NavigationItemView: View {
    
    let person: Person
    @State private var presentViewOnNavigationStack: Bool = false
    @State private var personToNavigateTo: Person? = nil

    var body: some View {
        VStack {
            Text(person.name)
            NavigationLink {
                SheetItemView(person: person)
            } label: {
                Text("Next View by NavigationLink")
            }
            Divider()
            Button {
                presentViewOnNavigationStack = true
            } label: {
                Text("Next View by navigationDestination with Boolean")
            }
            Divider()
            Button {
                personToNavigateTo = Person(name: "Maria")
            } label: {
                Text("Next View by navigationDestination with Item")
            }
            Divider()
            NavigationLink(value: Person(name: "Pedro")) {
                Text("Next View by navigationDestination with Hashable Value")
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
        .navigationDestination(isPresented: $presentViewOnNavigationStack) {
            SheetItemView(person: person)
        }
        .navigationDestination(item: $personToNavigateTo) { person in
            SheetItemView(person: person)
        }
        .navigationDestination(for: Person.self) { person in
            SheetItemView(person: person)
        }
    }
}
