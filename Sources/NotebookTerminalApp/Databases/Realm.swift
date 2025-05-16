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

    mutating func run() async throws {
        await MainActor.run {
            realmRunner()
        }
    }
}

class Settings: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var volume: Int = 0
    @objc dynamic var lang: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}

class Vehicle: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var licensePlate: String = ""
    @objc dynamic var model: String = ""
    @objc dynamic var manufacture: String = ""
    @objc dynamic var year: Int = 0
    @objc dynamic var owner: User?

    override static func primaryKey() -> String? {
        return "id"
    }
}

class Group: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var descriptions: String?
    let users = LinkingObjects(fromType: User.self, property: "groups")

    override static func primaryKey() -> String? {
        return "id"
    }
}

class User: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var document: String = ""
    @objc dynamic var settings: Settings?
    let vehicles = List<Vehicle>()
    let groups = List<Group>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

/// Singleton para abrir o banco
class RealmDatabaseManager {
    @MainActor static let shared = RealmDatabaseManager()
    var realm: Realm?

    private init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!.path)
        // /Users/<user>/Library/Application Support/<appName>/default.realm
        // Insira no Finder: Command + Shift + G
        do {
            realm = try Realm()
        } catch {
            print("Não foi possivel se conectar ao realm: \(error)")
        }
    }
}

@MainActor
struct RealmSettingsRepository {
    private let realm = RealmDatabaseManager.shared.realm

    // Create
    @discardableResult
    func add(volume: Int?, lang: String?) throws -> Settings {
        let settings = Settings()
        settings.volume = volume ?? 0
        settings.lang = lang
        do {
            try realm!.write {
                realm!.add(settings)
            }
        } catch {
            print("Deu error na criação da categoria: \(error)")
        }

        return settings
    }

    // Update
    func update(_ settings: Settings, volume: Int?, lang: String?) throws {
        do {
            try realm!.write {
                settings.volume = volume ?? 0
                settings.lang = lang
            }
        } catch {
            fatalError("Deu error na atualização do usuario: \(error)")
        }
    }

    // Delete
    func delete(_ setting: Settings) throws {
        do {
            try realm!.write {
                realm!.delete(setting)
            }
        } catch {
            fatalError("Deu error na deleção das configuraçoes do usuario: \(error)")
        }
    }
}

@MainActor
struct RealmUserRepository {
    private let realm = RealmDatabaseManager.shared.realm

    // Create
    func add(name: String, document: String, settings: Settings? = nil) throws -> User {
        let user = User()
        user.name = name
        user.document = document
        user.settings = settings

        do {
            try realm!.write {
                realm!.add(user)
            }
        } catch {
            fatalError("Deu error na criação do usuario: \(error)")
        }
        return user
    }

    // Read all
    func all() throws -> Results<User> {
        return realm!.objects(User.self)
    }

    func get(by id: String) throws -> User? {
        return realm!.object(ofType: User.self, forPrimaryKey: id)
    }

    // Filter by title
    func fetch(name: String) throws -> Results<User> {
        let users = realm!.objects(User.self)
        return users.filter("name CONTAINS[cd] %@", name).sorted(byKeyPath: "name", ascending: true)
    }

    // Update
    func update(_ user: User, name: String? = nil, document: String? = nil) throws {
        do {
            try realm!.write {
                if let newName = name { user.name = newName }
                if let newDoc = document { user.document = newDoc }
            }
        } catch {
            fatalError("Deu error na atualização do usuario: \(error)")
        }
    }

    // Delete
    func delete(_ user: User) throws {
        do {
            try realm!.write {
                realm!.delete(user)
            }
        } catch {
            fatalError("Deu error na deleção do usuario: \(error)")
        }
    }

    func removeVehicle(_ vehicle: Vehicle, from user: User) {
        try? realm!.write {
            if let idx = user.vehicles.index(of: vehicle) {
                user.vehicles.remove(at: idx)
            }
            realm!.delete(vehicle)
        }
    }
}

@MainActor
struct RealmVehicleRepository {
    private let realm = RealmDatabaseManager.shared.realm

    // Create
    func add(
        for user: User,
        licensePlate: String,
        model: String,
        manufacture: String,
        year: Int) throws -> Vehicle {
        let vehicle = Vehicle()
        vehicle.licensePlate = licensePlate
        vehicle.model = model
        vehicle.manufacture = manufacture
        vehicle.year = year
        vehicle.owner = user

        do {
            try realm!.write {
                realm!.add(vehicle)
                user.vehicles.append(vehicle)
            }
        } catch {
            fatalError("Deu error na criação do veículo: \(error)")
        }
        return vehicle
    }

    // Read all
    func all(by user: User) throws -> Results<Vehicle> {
        let vehicles = realm!.objects(Vehicle.self)
        return vehicles.filter("owner.id == %@", user.id)
    }

    func get(by id: String) throws -> Vehicle? {
        return realm!.object(ofType: Vehicle.self, forPrimaryKey: id)
    }

    // Update
    func update(
        _ vehicle: Vehicle,
        licensePlate: String? = nil,
        model: String? = nil,
        manufacture: String? = nil,
        year: Int? = nil) throws {
        do {
            try realm!.write {
                if let newLP = licensePlate { vehicle.licensePlate = newLP }
                if let newModel = model { vehicle.model = newModel }
                if let newMF = manufacture { vehicle.manufacture = newMF }
                if let newYear = year { vehicle.year = newYear }
            }
        } catch {
            fatalError("Deu error na atualização do veículo: \(error)")
        }
    }

    // Delete
    func delete(_ vehicle: Vehicle) throws {
        do {
            try realm!.write {
                realm!.delete(vehicle)
            }
        } catch {
            fatalError("Deu error na deleção do veículo: \(error)")
        }
    }
}

@MainActor
struct RealmGroupRepository {
    private let realm = RealmDatabaseManager.shared.realm

    // Create
    func add(name: String, description: String?) throws -> Group {
        let group = Group()
        group.name = name
        group.descriptions = description

        do {
            try realm!.write {
                realm!.add(group)
            }
        } catch {
            fatalError("Deu error na criação do grupo: \(error)")
        }
        return group
    }

    // Read all
    func all() throws -> Results<Group> {
        return realm!.objects(Group.self)
    }

    func get(by id: String) throws -> Group? {
        return realm!.object(ofType: Group.self, forPrimaryKey: id)
    }

    // Update
    func update(_ group: Group, name: String? = nil, description: String? = nil) throws {
        do {
            try realm!.write {
                if let newName = name { group.name = newName }
                if let newDescription = description { group.descriptions = newDescription }
            }
        } catch {
            fatalError("Deu error na atualização do grupo: \(error)")
        }
    }

    // Delete
    func delete(_ group: Group) throws {
        do {
            try realm!.write {
                realm!.delete(group)
            }
        } catch {
            fatalError("Deu error na deleção do grupo: \(error)")
        }
    }

    func addUser(_ user: User, to group: Group) {
        try? realm!.write {
            if !user.groups.contains(group) {
                user.groups.append(group)
            }
        }
    }

    func removeUser(_ user: User, from group: Group) {
        try? realm!.write {
            if let idx = user.groups.index(of: group) {
                user.groups.remove(at: idx)
            }
        }
    }
}

@MainActor
func realmRunner() { // swiftlint:disable:this function_body_length
    let settingsRepository = RealmSettingsRepository()
    let userRepository     = RealmUserRepository()
    let vehicleRepository  = RealmVehicleRepository()
    let groupRepository    = RealmGroupRepository()

    do {
        // 1. Criar Settings
        let settings = try settingsRepository.add(volume: 5, lang: "pt-BR")
        print("🔧 Settings criadas:", settings.id)

        // 2. Criar Usuário com Settings
        let user = try userRepository.add(name: "Alice", document: "123.456.789-00", settings: settings)
        print("👤 Usuário criado:", user.name)

        // 3. Criar Veículos para o Usuário
        let vehicle1 = try vehicleRepository.add(
            for: user,
            licensePlate: "ABC-1234",
            model: "Civic",
            manufacture: "Honda",
            year: 2020
        )
        let vehicle2 = try vehicleRepository.add(
            for: user,
            licensePlate: "XYZ-9876",
            model: "Corolla",
            manufacture: "Toyota",
            year: 2021
        )
        print("🚗 Veículos criados para \(user.name): \(vehicle1.model) & \(vehicle2.model)")

        // 4. Criar Grupos e adicionar Usuário
        let group1 = try groupRepository.add(name: "Admins", description: "Grupo de administradores")
        let group2 = try groupRepository.add(name: "Testers", description: nil)
        groupRepository.addUser(user, to: group1)
        groupRepository.addUser(user, to: group2)
        print("👥 \(user.name) adicionado aos grupos:", group1.name, "&", group2.name)

        // 5. Listar
        let allUsers    = try userRepository.all()
        let allVehicles = try vehicleRepository.all(by: user)
        let allGroups   = try groupRepository.all()

        print("📋 Usuários:", allUsers.map { $0.name }.joined(separator: ", "))
        print("📋 Veículos de \(user.name):", allVehicles.map { $0.model }.joined(separator: ", "))
        print("📋 Grupos:", allGroups.map { $0.name }.joined(separator: ", "))

        // 6. Atualizar alguns registros
        try settingsRepository.update(settings, volume: 8, lang: "en-US")
        try userRepository.update(user, name: "Alice Santos", document: nil)
        try vehicleRepository.update(vehicle1, licensePlate: "ABC-0000", model: nil, manufacture: nil, year: 2022)
        try groupRepository.update(group2, name: "Quality Testers", description: "Equipe de QA")

        print("✏️ Atualizações aplicadas:")
        print("   • Settings lang:", settings.lang!)
        print("   • Usuário name:", user.name)
        print("   • Veículo model:", vehicle1.model)
        print("   • Grupo name:", group2.name)

        // 7. Buscar por filtro (ex.: usuário por nome)
        let filteredUsers = try userRepository.fetch(name: "Alice")
        print("🔍 Usuários filtrados (\"Alice\"):", filteredUsers.map { $0.name }.joined(separator: ", "))

        // 8. Remoções
        //    a) remover vehicle2 do usuário e deletar vehicle2
        userRepository.removeVehicle(vehicle2, from: user)
        //    b) remover usuário do grupo group1
        groupRepository.removeUser(user, from: group1)
        //    c) deletar g1
        try groupRepository.delete(group1)

        print("🗑️ Remoções feitas.")

        // 9. Listar de novo para ver estado final
        let finalVehicles = try vehicleRepository.all(by: user)
        let finalGroups   = try groupRepository.all()

        print("📋 Veículos finais de \(user.name):", finalVehicles.map { $0.model }.joined(separator: ", "))
        print("📋 Grupos finais:", finalGroups.map { $0.name }.joined(separator: ", "))

        print("Limpando banco")
        try groupRepository.delete(group2)
        try vehicleRepository.delete(vehicle1)
        try settingsRepository.delete(settings)
        try userRepository.delete(user)
    } catch {
        print("❌ Erro durante CRUD demo:", error)
    }
} // swiftlint:disable:this file_length
