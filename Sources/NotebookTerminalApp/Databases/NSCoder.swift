// Usado para armazenar dados que o user defaults não consegue como objetos, arrays de objetos e etc.
// É criado um plist mais performatico que o user defaults.
// Pode ser considerado um banco de dados mais simples NoSQL.

import AppKit
import ArgumentParser

struct NSCoderCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "nscoder",
        abstract: "Tutorial sobre nscoder store em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        nscodeRunner()
    }
}

// Codable = Encodable + Decodable
struct TodoItem: Codable {
    var title: String = ""
    var done: Bool = false
}

func nscodeRunner() {
    let dataFilePath = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first?.appendingPathComponent("items.plist")
    
    print(dataFilePath!)
    // /Users/<user>/Library/Developer/CoreSimulator/Devices/<deviceId>/data/Containers/Data/Application/<appId>/Documents/items.plist
    // /Users/<username>/Documents/items.plist
    
    let item1 = TodoItem(title: "Item 01", done: true)
    let item2 = TodoItem(title: "Item 02", done: true)
    let item3 = TodoItem(title: "Item 03", done: false)
    
    let items: [TodoItem] = [item1, item2, item3]

    // Salvando os dados
    let encoder = PropertyListEncoder()
    do {
        let data = try encoder.encode(items)
        try data.write(to: dataFilePath!)
        print("Dados armazenados com successo!")
    } catch {
        print("Error ao encode o array de items: \(error)")
    }
    
    // Carregando os dados
    var currentItems: [TodoItem] = []
    if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
        do {
            // para especificar o tipo a gente usa o self do objeto
            currentItems = try decoder.decode([TodoItem].self, from: data)
            print("Dados recuperados do plist: \(currentItems)")
            // Dados recuperados do plist: [
                // NotebookTerminalApp.Item(title: "Item 01", done: true),
                // NotebookTerminalApp.Item(title: "Item 02", done: true),
                // NotebookTerminalApp.Item(title: "Item 03", done: false)
            //]
        } catch {
            print("Ocorreu um error ao carregar os items: \(error)")
        }
    }
    
    try? FileManager.default.removeItem(at: dataFilePath!)
}


