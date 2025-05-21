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

    mutating func run() async throws {
        await MainActor.run {
            sqliteRunner()
        }
    }
}

// MARK: - Models
fileprivate struct Settings: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var volume: Int = 0
    var lang: String?
    static let databaseTableName = "settings"
}

fileprivate struct User: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var name: String
    var document: String
    var settingsId: String?
    static let databaseTableName = "users"
}

fileprivate struct Vehicle: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var licensePlate: String
    var model: String
    var manufacture: String
    var year: Int
    var ownerId: String
    static let databaseTableName = "vehicles"
}

fileprivate struct Group: Codable, FetchableRecord, PersistableRecord {
    var id: String = UUID().uuidString
    var name: String
    var descriptions: String?
    static let databaseTableName = "groups"
}

fileprivate struct UserGroup: Codable, FetchableRecord, PersistableRecord {
    var userId: String
    var groupId: String
    static let databaseTableName = "user_group"
}

/// Singleton para abrir e migrar o banco
fileprivate class DatabaseManager {
    @MainActor static let shared = DatabaseManager()
    let dbQueue: DatabaseQueue

    private init() {
        print("Executado somente uma unica vez.")
        // Caminho do SQLite na pasta Documents
        let fileManager = FileManager.default
        let folderURL = try? fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let dbURL = folderURL!.appendingPathComponent("NotebookTerminalApp/app.sqlite")
        print("DB URL: \(dbURL)")
        try? fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true)

        // Open or create the database
        // swiftlint:disable:next force_try
        dbQueue = try! DatabaseQueue(path: dbURL.path)

        // Database migrations
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createTables") { database in
            // Settings table
            try database.create(table: "settings") { table in
                table.column("id", .text).primaryKey()
                table.column("volume", .integer).notNull().defaults(to: 0)
                table.column("lang", .text)
            }
            // Users table
            try database.create(table: "users") { table in
                table.column("id", .text).primaryKey()
                table.column("name", .text).notNull()
                table.column("document", .text).notNull()
                table.column("settingsId", .text).references("settings", onDelete: .setNull)
            }
            // Vehicles table
            try database.create(table: "vehicles") { table in
                table.column("id", .text).primaryKey()
                table.column("licensePlate", .text).notNull()
                table.column("model", .text).notNull()
                table.column("manufacture", .text).notNull()
                table.column("year", .integer).notNull()
                table.column("ownerId", .text).notNull().indexed().references("users", onDelete: .cascade)
            }
            // Groups table
            try database.create(table: "groups") { table in
                table.column("id", .text).primaryKey()
                table.column("name", .text).notNull()
                table.column("descriptions", .text)
            }
            // Junction table for many-to-many User-Group
            try database.create(table: "user_group") { table in
                table.column("userId", .text).notNull().references("users", onDelete: .cascade)
                table.column("groupId", .text).notNull().references("groups", onDelete: .cascade)
                table.primaryKey(["userId", "groupId"])
            }
        }
        try? migrator.migrate(dbQueue)
    }
}

fileprivate typealias DATABASE = DatabaseManager

@MainActor
fileprivate class SettingsRepository {
    let dbQueue = DATABASE.shared.dbQueue

    @discardableResult
    func add(volume: Int?, lang: String?) throws -> Settings {
        var settings = Settings()
        settings.volume = volume ?? 0
        settings.lang = lang
        try dbQueue.write { database in
            try settings.insert(database)
        }
        return settings
    }

    func update(_ settings: inout Settings, volume: Int?, lang: String?) throws {
        try dbQueue.write { database in
            settings.volume = volume ?? settings.volume
            settings.lang = lang ?? settings.lang
            try settings.update(database)
        }
    }

    func delete(_ settings: Settings) throws -> Bool {
        return try dbQueue.write { database in
            try settings.delete(database)
        }
    }
}

@MainActor
fileprivate class UserRepository {
    let dbQueue = DATABASE.shared.dbQueue

    func add(name: String, document: String, settingsId: String? = nil) throws -> User {
        let user = User(name: name, document: document, settingsId: settingsId)
        try dbQueue.write { database in
            try user.insert(database)
        }
        return user
    }

    func all() throws -> [User] {
        try dbQueue.read { database in
            try User.fetchAll(database)
        }
    }

    func get(by id: String) throws -> User? {
        try dbQueue.read { database in
            try User.fetchOne(database, key: id)
        }
    }

    func fetch(name: String) throws -> [User] {
        try dbQueue.read { database in
            try User
                .filter(sql: "name LIKE '%' || ? || '%'", arguments: [name])
                .order(Column("name"))
                .fetchAll(database)
        }
    }

    func update(_ user: inout User, name: String? = nil, document: String? = nil) throws {
        try dbQueue.write { database in
            if let newName = name { user.name = newName }
            if let newDoc = document { user.document = newDoc }
            try user.update(database)
        }
    }

    func delete(_ user: User) throws -> Bool {
        return try dbQueue.write { database in
            try user.delete(database)
        }
    }
}

@MainActor
fileprivate class VehicleRepository {
    let dbQueue = DATABASE.shared.dbQueue

    func add(
        for user: User,
        licensePlate: String,
        model: String,
        manufacture: String,
        year: Int) throws -> Vehicle {
        let vehicle = Vehicle(
            licensePlate: licensePlate,
            model: model,
            manufacture: manufacture,
            year: year,
            ownerId: user.id
        )
        try dbQueue.write { database in
            try vehicle.insert(database)
        }
        return vehicle
    }

    func all(by user: User) throws -> [Vehicle] {
        try dbQueue.read { database in
            try Vehicle.filter(Column("ownerId") == user.id).fetchAll(database)
        }
    }

    func get(by id: String) throws -> Vehicle? {
        try dbQueue.read { database in
            try Vehicle.fetchOne(database, key: id)
        }
    }

    func update(
        _ vehicle: inout Vehicle,
        licensePlate: String? = nil,
        model: String? = nil,
        manufacture: String? = nil,
        year: Int? = nil) throws {
        try dbQueue.write { database in
            if let newLP = licensePlate { vehicle.licensePlate = newLP }
            if let newModel = model { vehicle.model = newModel }
            if let newMF = manufacture { vehicle.manufacture = newMF }
            if let newYear = year { vehicle.year = newYear }
            try vehicle.update(database)
        }
    }

    func delete(_ vehicle: Vehicle) throws -> Bool {
        return try dbQueue.write { database in
            try vehicle.delete(database)
        }
    }
}

@MainActor
fileprivate class GroupRepository {
    let dbQueue = DATABASE.shared.dbQueue

    func add(name: String, description: String?) throws -> Group {
        let group = Group(name: name, descriptions: description)
        try dbQueue.write { database in
            try group.insert(database)
        }
        return group
    }

    func all() throws -> [Group] {
        try dbQueue.read { database in
            try Group.fetchAll(database)
        }
    }

    func get(by id: String) throws -> Group? {
        try dbQueue.read { database in
            try Group.fetchOne(database, key: id)
        }
    }

    func update(_ group: inout Group, name: String? = nil, description: String? = nil) throws {
        try dbQueue.write { database in
            if let newName = name { group.name = newName }
            if let newDescription = description { group.descriptions = newDescription }
            try group.update(database)
        }
    }

    func delete(_ group: Group) throws -> Bool {
        return try dbQueue.write { database in
            try group.delete(database)
        }
    }

    func addUser(_ user: User, to group: Group) throws {
        let userGroup = UserGroup(userId: user.id, groupId: group.id)
        try dbQueue.write { database in
            try userGroup.insert(database)
        }
    }

    func removeUser(_ user: User, from group: Group) throws {
        try dbQueue.write { database in
            try database.execute(
                sql: """
                    DELETE FROM user_group
                    WHERE userId = ? AND groupId = ?
                """,
                arguments: [user.id, group.id]
            )
        }
    }
}

@MainActor fileprivate func sqliteRunner() {
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
        var vehicle1 = try vehicleRepo.add(
            for: user,
            licensePlate: "ABC-1234",
            model: "Civic",
            manufacture: "Honda",
            year: 2020
        )
        let vehicle2 = try vehicleRepo.add(
            for: user,
            licensePlate: "XYZ-9876",
            model: "Corolla",
            manufacture: "Toyota",
            year: 2021
        )
        print("🚗 Vehicles created for \(user.name): \(vehicle1.model) & \(vehicle2.model)")

        // 4. Create Groups and add User
        let group1 = try groupRepo.add(name: "Admins", description: "Administrators group")
        var group2 = try groupRepo.add(name: "Testers", description: nil)
        try groupRepo.addUser(user, to: group1)
        try groupRepo.addUser(user, to: group2)
        print("👥 \(user.name) added to groups: \(group1.name) & \(group2.name)")

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
        try vehicleRepo.update(&vehicle1, licensePlate: "ABC-0000", year: 2022)
        try groupRepo.update(&group2, name: "Quality Testers", description: "QA Team")
        print("✏️ Updates applied")

        // 7. Filter Users by name
        let filtered = try userRepo.fetch(name: "Alice")
        print("🔍 Filtered users (\"Alice\"): \(filtered.map { $0.name }.joined(separator: ", "))")

        // 8. Removals
        _ = try vehicleRepo.delete(vehicle2)
        try groupRepo.removeUser(user, from: group1)
        _ = try groupRepo.delete(group1)
        print("🗑️ Removals done")

        // 9. Final state
        let finalVehicles = try vehicleRepo.all(by: user).map { $0.model }
        let finalGroups   = try groupRepo.all().map { $0.name }
        print("📋 Final vehicles of \(user.name): \(finalVehicles.joined(separator: ", "))")
        print("📋 Final groups: \(finalGroups.joined(separator: ", "))")

        // Cleanup
        _ = try groupRepo.delete(group2)
        _ = try vehicleRepo.delete(vehicle1)
        _ = try settingsRepo.delete(settings)
        _ = try userRepo.delete(user)
    } catch {
        print("❌ Erro durante CRUD:", error)
    }
}
