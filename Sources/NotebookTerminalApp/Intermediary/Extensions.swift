/*
 Em Swift, Extensions permitem adicionar novas funcionalidades a tipos já existentes —
 classes, structs, enums, protocolos ou tipos primitivos — sem precisar modificar o código
 original. Com elas você pode:
    1. Permitem adicionar métodos, propriedades computadas e conformidade a protocolos.
    2. Não podem adicionar stored properties.
    3. São excelentes para organizar funcionalidades relacionadas sem alterar o tipo original.
    4. Organizar melhor seu código em módulos.
 Boa prática:
    1. Documente cada método/propriedade na extension com comentários ///.
    2. Agrupe extensions por responsabilidade (ex.: extensão de formatação, de cálculo, de API, etc.).
*/

import Foundation
import AppKit
import ArgumentParser

struct ExtensionCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "extensions",
        abstract: "Tutorial sobre extensions em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let original: Double = 3.14159

        // 1) Arredondamento padrão (sem extension)
        print("Rounded padrão:", original.rounded())        // → 3.0

        // 2) Arredondamento customizado via extension
        print("1 casa decimal:", original.rounded(to: 1))   // → 3.1
        print("2 casas decimais:", original.rounded(to: 2)) // → 3.14
        print("3 casas decimais:", original.rounded(to: 3)) // → 3.142
        print("4 casas decimais:", original.rounded(to: 4)) // → 3.1416
        
        // 3) Equatable
        let user1 = User(id: 1, name: "Usuario 01")
        let user2 = User(id: 1, name: "Usuario 02")
        print(user1 == user2) // true
        print(user1 != user2) // false
        
        // 4) StringConvertable
        print(user1) // Usuario 01
        print(String(reflecting: user2)) // User10(Usuario 02)
        
        // 5) Comparable
        print(user1 > user2) // false
        print(user1 < user2) // false
        print(user1 >= user2) // true
        print(user1 <= user2) // true
        
        // 6) Hashable
        // como os usuarios tem o mesmo id eles são considerados repetidos
        let users: Set<User> = Set<User>([user1, user2])
        print(users.count) // 1
    }
}

/// Adiciona função de arredondamento customizado a Double
fileprivate extension Double {
    /// Retorna o valor arredondado para 'places' casas decimais
    ///
    /// - Parameter places: número de casas decimais desejadas
    /// - Returns: valor arredondado
    func rounded(to places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        // Multiplica, arredonda e depois divide de volta
        return (self * factor).rounded() / factor
    }
}

fileprivate struct User {
    var id: Int
    var name: String
}

/// Equatable Protocol
/// Qualquer tipo que implementar o protocolo Equatable pode modificar o comportamento do == e do !=
/// Metodos como o filter ou outros precisa da implementação desse protocolo.
/// Struct e Enums já implementa esse protocolo
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func != (lhs: User, rhs: User) -> Bool {
        return lhs.id != rhs.id
    }
}

/// Modifica o print do objeto
extension User: CustomStringConvertible {
    public var description: String {
        return name
    }
}

/// Modifica o print com String(reflecting: ...) e dentro de arrays
extension User: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "User(\(description))"
    }
}

/// Permite modificar o comportamrnto dos operadores `< > <= >=`
/// Se extender o Comparable você pode sobrescrever tb o `==` e o `!=`
/// Metodos como sort e sorted precisa que o objeto implemente esse protocolo
/// Struct e Enums já implementa esse protocolo
extension User: Comparable {
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func > (lhs: User, rhs: User) -> Bool {
        return lhs.id > rhs.id
    }
    
    static func <= (lhs: User, rhs: User) -> Bool {
        return lhs.id <= rhs.id
    }
    
    static func >= (lhs: User, rhs: User) -> Bool {
        return lhs.id >= rhs.id
    }
}

/// Usado em Set e Dictionary para deixar a chave do dicionario e os elementos do Set unico.
/// Struct e Enums já implementa esse protocolo
extension User: Hashable {
    /// Vamos tornar o objeto user unico a partir de seu ID
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
