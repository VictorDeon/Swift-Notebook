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

// MARK: - Models
struct QLSettings: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var volume: Int = 0
    var lang: String?
    static let databaseTableName = "settings"
}

struct QLUser: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var name: String
    var document: String
    var settingsId: String?
    static let databaseTableName = "users"
}

struct QLVehicle: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var licensePlate: String
    var model: String
    var manufacture: String
    var year: Int
    var ownerId: String
    static let databaseTableName = "vehicles"
}

struct QLGroup: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var name: String
    var descriptions: String?
    static let databaseTableName = "groups"
}

struct UserGroup: Codable, FetchableRecord, PersistableRecord {
    var userId: String
    var groupId: String
    static let databaseTableName = "user_group"
}

/// Singleton para abrir e migrar o banco
class DatabaseManager {
    @MainActor static let shared = DatabaseManager()
    let dbQueue: DatabaseQueue

    private init() {
        print("Executado somente uma unica vez.")
        // Caminho do SQLite na pasta Documents
        let fm = FileManager.default
        let folderURL = try! fm.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let dbURL = folderURL.appendingPathComponent("NotebookTerminalApp/app.sqlite")
        print("DB URL: \(dbURL)")
        try! fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        // Open or create the database
        dbQueue = try! DatabaseQueue(path: dbURL.path)
        
        // Database migrations
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createTables") { db in
            // Settings table
            try db.create(table: "settings") { t in
                t.column("id", .text).primaryKey()
                t.column("volume", .integer).notNull().defaults(to: 0)
                t.column("lang", .text)
            }
            // Users table
            try db.create(table: "users") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("document", .text).notNull()
                t.column("settingsId", .text).references("settings", onDelete: .setNull)
            }
            // Vehicles table
            try db.create(table: "vehicles") { t in
                t.column("id", .text).primaryKey()
                t.column("licensePlate", .text).notNull()
                t.column("model", .text).notNull()
                t.column("manufacture", .text).notNull()
                t.column("year", .integer).notNull()
                t.column("ownerId", .text).notNull().indexed().references("users", onDelete: .cascade)
            }
            // Groups table
            try db.create(table: "groups") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("descriptions", .text)
            }
            // Junction table for many-to-many User-Group
            try db.create(table: "user_group") { t in
                t.column("userId", .text).notNull().references("users", onDelete: .cascade)
                t.column("groupId", .text).notNull().references("groups", onDelete: .cascade)
                t.primaryKey(["userId", "groupId"])
            }
        }
        try! migrator.migrate(dbQueue)
    }
}

typealias DB = DatabaseManager

@MainActor
class SettingsRepository {
    let db = DB.shared.dbQueue

    @discardableResult
    func add(volume: Int?, lang: String?) throws -> QLSettings {
        var settings = QLSettings()
        settings.volume = volume ?? 0
        settings.lang = lang
        try db.write { db in
            try settings.insert(db)
        }
        return settings
    }

    func update(_ settings: inout QLSettings, volume: Int?, lang: String?) throws {
        try db.write { db in
            settings.volume = volume ?? settings.volume
            settings.lang = lang ?? settings.lang
            try settings.update(db)
        }
    }

    func delete(_ settings: QLSettings) throws -> Bool {
        return try db.write { db in
            try settings.delete(db)
        }
    }
}

@MainActor
class UserRepository {
    let db = DB.shared.dbQueue

    func add(name: String, document: String, settingsId: String? = nil) throws -> QLUser {
        let user = QLUser(name: name, document: document, settingsId: settingsId)
        try db.write { db in
            try user.insert(db)
        }
        return user
    }

    func all() throws -> [QLUser] {
        try db.read { db in
            try QLUser.fetchAll(db)
        }
    }

    func get(by id: String) throws -> QLUser? {
        try db.read { db in
            try QLUser.fetchOne(db, key: id)
        }
    }

    func fetch(name: String) throws -> [QLUser] {
        try db.read { db in
            try QLUser
                .filter(sql: "name LIKE '%' || ? || '%'", arguments: [name])
                .order(Column("name"))
                .fetchAll(db)
        }
    }

    func update(_ user: inout QLUser, name: String? = nil, document: String? = nil) throws {
        try db.write { db in
            if let n = name { user.name = n }
            if let d = document { user.document = d }
            try user.update(db)
        }
    }

    func delete(_ user: QLUser) throws -> Bool {
        return try db.write { db in
            try user.delete(db)
        }
    }
}

@MainActor
class VehicleRepository {
    let db = DB.shared.dbQueue

    func add(for user: QLUser, licensePlate: String, model: String, manufacture: String, year: Int) throws -> QLVehicle {
        let vehicle = QLVehicle(
            licensePlate: licensePlate,
            model: model,
            manufacture: manufacture,
            year: year,
            ownerId: user.id
        )
        try db.write { db in
            try vehicle.insert(db)
        }
        return vehicle
    }

    func all(by user: QLUser) throws -> [QLVehicle] {
        try db.read { db in
            try QLVehicle.filter(Column("ownerId") == user.id).fetchAll(db)
        }
    }

    func get(by id: String) throws -> QLVehicle? {
        try db.read { db in
            try QLVehicle.fetchOne(db, key: id)
        }
    }

    func update(_ vehicle: inout QLVehicle, licensePlate: String? = nil, model: String? = nil, manufacture: String? = nil, year: Int? = nil) throws {
        try db.write { db in
            if let lp = licensePlate { vehicle.licensePlate = lp }
            if let m = model { vehicle.model = m }
            if let mf = manufacture { vehicle.manufacture = mf }
            if let y = year { vehicle.year = y }
            try vehicle.update(db)
        }
    }

    func delete(_ vehicle: QLVehicle) throws -> Bool {
        return try db.write { db in
            try vehicle.delete(db)
        }
    }
}

@MainActor
class GroupRepository {
    let db = DB.shared.dbQueue

    func add(name: String, description: String?) throws -> QLGroup {
        let group = QLGroup(name: name, descriptions: description)
        try db.write { db in
            try group.insert(db)
        }
        return group
    }

    func all() throws -> [QLGroup] {
        try db.read { db in
            try QLGroup.fetchAll(db)
        }
    }

    func get(by id: String) throws -> QLGroup? {
        try db.read { db in
            try QLGroup.fetchOne(db, key: id)
        }
    }

    func update(_ group: inout QLGroup, name: String? = nil, description: String? = nil) throws {
        try db.write { db in
            if let n = name { group.name = n }
            if let d = description { group.descriptions = d }
            try group.update(db)
        }
    }

    func delete(_ group: QLGroup) throws -> Bool {
        return try db.write { db in
            try group.delete(db)
        }
    }

    func addUser(_ user: QLUser, to group: QLGroup) throws {
        let ug = UserGroup(userId: user.id, groupId: group.id)
        try db.write { db in
            try ug.insert(db)
        }
    }
    
    func removeUser(_ user: QLUser, from group: QLGroup) throws {
        try db.write { db in
            try db.execute(
                sql: """
                    DELETE FROM user_group
                    WHERE userId = ? AND groupId = ?
                """,
                arguments: [user.id, group.id]
            )
        }
    }
}


@MainActor func sqliteRunner() {
    let settingsRepo = SettingsRepository()
    let userRepo     = UserRepository()
    let vehicleRepo  = VehicleRepository()
    let groupRepo    = GroupRepository()

    do {
        // 1. Create Settings
        var settings = try settingsRepo.add(volume: 5, lang: "pt-BR")
        print("🔧 Settings created: \(settings.id)")

        // 2. Create User with Settings
        var user = try userRepo.add(name: "Alice", document: "123.456.789-00", settingsId: settings.id)
        print("👤 User created: \(user.name)")

        // 3. Create Vehicles for User
        var v1 = try vehicleRepo.add(
            for: user,
            licensePlate: "ABC-1234",
            model: "Civic",
            manufacture: "Honda",
            year: 2020
        )
        let v2 = try vehicleRepo.add(
            for: user,
            licensePlate: "XYZ-9876",
            model: "Corolla",
            manufacture: "Toyota",
            year: 2021
        )
        print("🚗 Vehicles created for \(user.name): \(v1.model) & \(v2.model)")

        // 4. Create Groups and add User
        let g1 = try groupRepo.add(name: "Admins", description: "Administrators group")
        var g2 = try groupRepo.add(name: "Testers", description: nil)
        try groupRepo.addUser(user, to: g1)
        try groupRepo.addUser(user, to: g2)
        print("👥 \(user.name) added to groups: \(g1.name) & \(g2.name)")

        // 5. List all
        let allUsers    = try userRepo.all().map { $0.name }
        let allVehicles = try vehicleRepo.all(by: user).map { $0.model }
        let allGroups   = try groupRepo.all().map { $0.name }
        print("📋 Users: \(allUsers.joined(separator: ", "))")
        print("📋 Vehicles of \(user.name): \(allVehicles.joined(separator: ", "))")
        print("📋 Groups: \(allGroups.joined(separator: ", "))")

        // 6. Updates
        try settingsRepo.update(&settings, volume: 8, lang: "en-US")
        try userRepo.update(&user, name: "Alice Santos")
        try vehicleRepo.update(&v1, licensePlate: "ABC-0000", year: 2022)
        try groupRepo.update(&g2, name: "Quality Testers", description: "QA Team")
        print("✏️ Updates applied")

        // 7. Filter Users by name
        let filtered = try userRepo.fetch(name: "Alice")
        print("🔍 Filtered users (\"Alice\"): \(filtered.map { $0.name }.joined(separator: ", "))")

        // 8. Removals
        _ = try vehicleRepo.delete(v2)
        try groupRepo.removeUser(user, from: g1)
        _ = try groupRepo.delete(g1)
        print("🗑️ Removals done")

        // 9. Final state
        let finalVehicles = try vehicleRepo.all(by: user).map { $0.model }
        let finalGroups   = try groupRepo.all().map { $0.name }
        print("📋 Final vehicles of \(user.name): \(finalVehicles.joined(separator: ", "))")
        print("📋 Final groups: \(finalGroups.joined(separator: ", "))")

        // Cleanup
        _ = try groupRepo.delete(g2)
        _ = try vehicleRepo.delete(v1)
        _ = try settingsRepo.delete(settings)
        _ = try userRepo.delete(user)
    } catch {
        print("❌ Erro durante CRUD:", error)
    }
}


