// É uma soluçãp de banco de dados que pode substituir o SQLite ou o Core Data

// Usado para armazenar dados que o user defaults não consegue como objetos, arrays de objetos e etc.
// É criado um plist mais performatico que o user defaults.
// Pode ser considerado um banco de dados mais simples NoSQL.
// Para visualizar os arquivos do realm pode-se baixar um software no app store chamado Realm browser

import AppKit
import ArgumentParser
import RealmSwift

struct RealmCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "realm",
        abstract: "Tutorial sobre realm store em swift"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws -> Void {
        await MainActor.run {
            realmRunner()
        }
    }
}

/// Modelo de Todo
class ToDo: Object {
    // dynamic monitora por mudanças nesses atributos em tempo real
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var category = LinkingObjects(fromType: Category.self, property: "items")
}

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<ToDo>()
}

/// Singleton para abrir o banco
class RealmDatabaseManager {
    @MainActor static let shared = RealmDatabaseManager()
    var realm: Realm

    private init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!.path)
        // /Users/<user>/Library/Application Support/<appName>/default.realm
        // Insira no Finder: Command + Shift + G
        realm = try! Realm()
    }
}

@MainActor
struct RealmCategoryRepository {
    private let realm = RealmDatabaseManager.shared.realm

    // Create
    func add(name: String) throws -> Category {
        let category = Category()
        category.name = name
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Deu error na criação da categoria: \(error)")
        }
        return category
    }

    // Read all
    func all() throws -> Results<Category> {
        return realm.objects(Category.self)
    }

    // Update
    func update(_ category: Category, name: String) throws -> Void {
        do {
            try realm.write {
                category.name = name
            }
        } catch {
            print("Deu error na atualização da categoria: \(error)")
        }
    }

    // Delete
    func delete(_ category: Category) throws -> Bool {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Deu error na deleção da categoria: \(error)")
            return false
        }
        return true
    }
}

@MainActor
struct RealmTodoRepository {
    private let realm = RealmDatabaseManager.shared.realm

    // Create
    func add(title: String) throws -> ToDo {
        let todo = ToDo()
        todo.title = title
        
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch {
            print("Deu error na criação do todo: \(error)")
        }
        return todo
    }

    // Read all
    func all() throws -> Results<ToDo> {
        return realm.objects(ToDo.self)
    }
    
    // Filter by title
    func fetch(title: String) throws -> Results<ToDo> {
        let items = realm.objects(ToDo.self)
        return items.filter("title CONTAINS[cd] %@", title).sorted(byKeyPath: "title", ascending: true)
    }

    // Update
    func update(_ todo: ToDo, title: String, done: Bool) throws -> Void {
        do {
            try realm.write {
                todo.title = title
                todo.done = done
            }
        } catch {
            print("Deu error na atualização do todo: \(error)")
        }
    }

    // Delete
    func delete(_ todo: ToDo) throws -> Bool {
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            print("Deu error na deleção do todo: \(error)")
            return false
        }
        return true
    }
}

@MainActor func realmRunner() {
    let repo = RealmTodoRepository()
    
    do {
        // 1. Criar alguns itens
        let t1 = try repo.add(title: "Comprar leite")
        let t2 = try repo.add(title: "Estudar GRDB")
        print("✅ Criados:", t1, t2)
        // Criados: Todo(id: Optional(1), title: "Comprar leite", done: false)
        //          Todo(id: Optional(2), title: "Estudar GRDB", done: false)

        // 2. Listar tudo
        var itens = try repo.all()
        print("📋 Todos:", itens)
        // Todos: [
        //      Todo(id: Optional(1), title: "Comprar leite", done: false),
        //      Todo(id: Optional(2), title: "Estudar GRDB", done: false)
        // ]

        // 3. Marcar o primeiro como feito e atualizar
        try repo.update(t1, title: "Comprar leitei quente!", done: true)
        print("✏️ Atualizado:", t1)
        // Atualizado: Todo(id: Optional(1), title: "Comprar leite", done: true)
        
        // 4. Só os feitos
        print("✅ Feitos:", try repo.fetch(title: "Comprar"))
        // Feitos: [Todo(id: Optional(1), title: "Comprar leite", done: true)]
        
        // 5. Deletar o segundo
        let success = try repo.delete(t2)
        if success {
            print("🗑️ Item deletado com sucesso")
        }

        // 6. Listar de novo
        itens = try repo.all()
        print("📋 Final:", itens)
        // Final: [Todo(id: Optional(1), title: "Comprar leite", done: true)]
    } catch {
        print("❌ Erro durante CRUD:", error)
    }
}


