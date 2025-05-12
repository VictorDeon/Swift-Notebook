// Usado para armazenar dados em varias tabelas SQL com relacionamento entre elas, diferente do NSCoder e do UserDefaults
// que armazena em uma unica tabela como um excel.
// Para inserir o CoreData vai em File → New → File From Template → Data Model
// Entity = Classe ou Table
// Property = Attribute ou Column
// Row = NSManagedObject
// Codegen Class Definition = Coverte suas entidades e atributos em classes e propriedades.
//                          = Localizado em: /Users/<user>/Library/Developer/DerivedData/<nomeDoApp>/
//                            Build/Intermediates.noindex/<nomeDoApp>.build/Debug-iphonesimulator/
//                            <nomeDoApp>.build/DerivedSources/CoreDataGenerated/DataModel/*.swift
// Codegen Category/Extension = Você pode extender as classes e atributos gerados pelo CoreData.
//                            = sua classe precisa ter o mesmo nome da Entidade. É o mais utilizado.
// Codegen Manual/None        = Não gera nenhum codigo.
// O banco SQLite criado fica em:
// /Users/<user>/Library/Developer/CoreSimulator/Devices/<deviceId>/data/Containers/Data/Application/<appId>/Library/Application Support/DataModel.sqlite
// PARECE QUE SO FUNCIONA NO BUILD DO IOS

import AppKit
import ArgumentParser
import CoreData
import Foundation

struct CoreDataCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "core-data",
        abstract: "Tutorial sobre Core Data store em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        coreDataRunner()
    }
}

// Ambos sao criados pelo CoreData (ta aqui so de exemplo)
public class Item: NSManagedObject {}

extension Item {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var done: Bool

}

// Usado para salvar os dados quando a aplicação IOS for terminada (applicationWillTerminate).
func saveContext(container: NSPersistentContainer) {
    // context é a sessao onde você pode manipular os dados antes de dar o commit para o BD.
    let context = container.viewContext
    // Se houver alguma mudança nos dados
    if context.hasChanges {
        do {
            // Realiza o commit dos dados para o banco
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

func coreDataRunner() {
    guard
        let modelURL = Bundle.module.url(
            forResource: "DataModel",
            withExtension: "xcdatamodeld"
        ),
        let model = NSManagedObjectModel(contentsOf: modelURL)
    else {
        fatalError("❌ Não encontrei DataModel.xcdatamodeld em Bundle.module")
        // TA CAINDO AQUI!!!!!
    }
    
    print("🔍 Entidades no modelo:", model.entitiesByName.keys)
    
    // Normalmente no IOS esses dados estarao em AppDelegate.swift
    // lazy ele só será preenchido com o valor quando for chamado. (memory benefit)
    // NSPersistentContainer é onde será armazenado todo os nossos dados (SQLite)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel", managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var items: [Item] = []

    // Create
    print("✅ Core Data Ready: \(persistentContainer)")
    let item = Item(context: persistentContainer.viewContext)
    item.title = "Ola mundo!"
    item.done = false
    saveContext(container: persistentContainer)
    
    // Read
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    do {
        items = try persistentContainer.viewContext.fetch(request)
        print(items)
    } catch {
        print("Error fetching data from context: \(error)")
    }
    // Update
    items[0].setValue("Titulo Atualizado", forKey: "title")
    saveContext(container: persistentContainer)
    
    // Delete
    items.remove(at: 0)
    persistentContainer.viewContext.delete(items[0])
    
}


