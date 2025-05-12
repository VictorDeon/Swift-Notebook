// Vamos utilizar o SQLite usando um framework GRDB

import AppKit
import ArgumentParser
import GRDB

struct SQLiteCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sqlite",
        abstract: "Tutorial sobre sqlite store em swift"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws -> Void {
        await MainActor.run {
            sqliteRunner()
        }
    }
}

/// Modelo de Todo
struct Todo: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?         // Primary key
    var title: String
    var done: Bool

    // Para PersistableRecord: defina a tabela
    static let databaseTableName = "todos"
}

/// Singleton para abrir e migrar o banco
class DatabaseManager {
    @MainActor static let shared = DatabaseManager()
    let dbQueue: DatabaseQueue

    private init() {
        print("Executado somente uma unica vez.")
        // Caminho do SQLite na pasta Documents
        let fm = FileManager.default
        let folder = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbURL = folder.appendingPathComponent("todos.sqlite")
        
        // Cria o DatabaseQueue
        do {
            dbQueue = try DatabaseQueue(path: dbURL.path)
        } catch {
            fatalError("Erro ao abrir banco: \(error)")
        }
        
        // Migração: cria a tabela se não existir
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createTodos") { db in
            try db.create(table: Todo.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("done", .boolean).notNull().defaults(to: false)
            }
        }
        do {
            try migrator.migrate(dbQueue)
        } catch {
            fatalError("Erro na migração: \(error)")
        }
    }
}

@MainActor
struct TodoRepository {
    private let dbQueue = DatabaseManager.shared.dbQueue

    // Create
    func add(title: String) throws -> Todo {
        let todo = Todo(id: nil, title: title, done: false)
        return try dbQueue.write { db in
            try todo.insertAndFetch(db)
        }
    }

    // Read all
    func all() throws -> [Todo] {
        try dbQueue.read { db in
            try Todo.order(Column("id")).fetchAll(db)
        }
    }
    
    // Filter by done status
    func fetch(done: Bool) throws -> [Todo] {
        try dbQueue.read { db in
            try Todo
                .filter(Column("done") == done)
                .order(Column("id"))
                .fetchAll(db)
        }
    }
    
    // Search by title substring (case-insensitive)
    func search(titleContains keyword: String) throws -> [Todo] {
        try dbQueue.read { db in
            let expr = Column("title").like("%\(keyword)%")
            return try Todo
                .filter(expr)
                .order(Column("id"))
                .fetchAll(db)
        }
    }

    // Combined filter: status + title substring
    func fetch(done: Bool, titleContains keyword: String) throws -> [Todo] {
        try dbQueue.read { db in
            let expr = Column("title").like("%\(keyword)%")
            return try Todo
                .filter(Column("done") == done && expr)
                .order(Column("id"))
                .fetchAll(db)
        }
    }
    
    // Search raw sql
    func raw(sql: String, arguments: StatementArguments = StatementArguments()) throws -> [Todo] {
        try dbQueue.read { db in
            return try Todo
                .filter(sql: sql, arguments: arguments)
                .order(Column("id"))
                .fetchAll(db)
        }
    }

    // Update
    func update(_ todo: Todo) throws -> Void {
        try dbQueue.write { db in
            try todo.update(db)
        }
    }

    // Delete
    func delete(id: Int64) throws -> Bool {
        return try dbQueue.write { db in
            try Todo.deleteOne(db, key: id)
        }
    }
}

@MainActor func sqliteRunner() {
    let repo = TodoRepository()
    
    do {
        // 1. Criar alguns itens
        var t1 = try repo.add(title: "Comprar leite")
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
        t1.done = true
        try repo.update(t1)
        print("✏️ Atualizado:", t1)
        // Atualizado: Todo(id: Optional(1), title: "Comprar leite", done: true)
        
        // 4. Só os feitos
        print("✅ Feitos:", try repo.fetch(done: true))
        // Feitos: [Todo(id: Optional(1), title: "Comprar leite", done: true)]
        
        // 5. Só os pendentes
        print("⏳ Pendentes:", try repo.fetch(done: false))
        // Pendentes: Todo(id: Optional(2), title: "Estudar GRDB", done: false)

        // 6. Buscar por palavra “Estudar”
        print("🔍 Buscando ‘Estudar’:", try repo.search(titleContains: "Estudar"))
        // Buscando ‘Estudar’: Todo(id: Optional(2), title: "Estudar GRDB", done: false)

        // 7. Pendentes que contenham “Enviar”
        print("⏳🔍 Pendentes ’Enviar’:", try repo.fetch(done: false, titleContains: "Enviar"))
        // Pendentes 'enviar': []
        
        // 8. Combinar várias condições em SQL puro
        let custom = try repo.raw(
            sql: "done = :done AND title LIKE :pattern",
            arguments: ["done": false, "pattern": "%Estudar%"]
        )
        print("✏️ Custom raw:", custom)
        // Custom raw: Todo(id: Optional(2), title: "Estudar GRDB", done: false)

        // 9. Deletar o segundo
        let success = try repo.delete(id: t2.id!)
        if success {
            print("🗑️ Item deletado com sucesso")
        }

        // 10. Listar de novo
        itens = try repo.all()
        print("📋 Final:", itens)
        // Final: [Todo(id: Optional(1), title: "Comprar leite", done: true)]
    } catch {
        print("❌ Erro durante CRUD:", error)
    }
}


