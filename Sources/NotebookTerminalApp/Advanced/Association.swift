// É o mecanismo pelo qual um objeto utiliza os recursos de outro, basicamente ele está vinculado a outra classe.
// Pode tratar-se de uma associação simples (1x1), associações complexas (1xN) ou (NxM), ou de um
// acoplamento (é parte de) que temos "composição" e "agregação".

import Foundation
import AppKit
import ArgumentParser

struct AssociationCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "association",
        abstract: "Tutorial sobre associações em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Associação 1x1 entre Pessoa e Endereço")
        Association1x1.execute()
        print("→ Associação 1xN entre Pessoa e Telefones")
        Association1xN.execute()
        print("→ Associação NxM entre Pessoas e Grupos")
        AssociationNxM.execute()
        print("→ Agregação entre Pedido e Items do pedido")
        Aggregation.execute()
        print("→ Composição entre Notebook e seu teclado")
        Composition.execute()
    }
}

struct Address1 {
    var zipCode: String
    var country: String?
    var state: String?
    var city: String?
    var neighborhood: String?
    var number: Int
    var complement: String?
}

struct Group1 {
    var name: String
    var people: [Person1] = []
}

struct Phone {
    var ddd: Int
    var number: Int
}

struct Person1 {
    var name: String
    var phone: String?
    var address: Address1?
    var groups: [Group1] = []
    var phones: [Phone] = []
}

struct Item1 {
    var title: String
    var price: Float
}

struct Order1 {
    var items: [Item1] = []
    var total: Float = 0

    init(items: [Item1]) {
        for item in items {
            self.items.append(item)
        }
    }

    mutating func getBill() -> Float {
        for item in self.items {
            self.total += item.price
        }
        return self.total
    }
}

class Keyboard {
    var model: String
    var notebook: Notebook

    init(model: String, notebook: Notebook) {
        self.model = model
        self.notebook = notebook
        self.notebook.keyboard = self
    }
}

class Notebook {
    var model: String
    var keyboard: Keyboard?

    init(model: String, keyboard: Keyboard?) {
        self.model = model
        self.keyboard = keyboard
    }

    init(model: String) {
        self.model = model
    }
}

/// Associação 1x1
struct Association1x1 {
    static func execute() {
        let brasilia = Address1(zipCode: "70658192", city: "Brasilia", number: 304)
        let fulana = Person1(name: "Ana", phone: "61992839456", address: brasilia)
        print(fulana.name)              // Ana
        print(fulana.phone!)            // 61992839456
        print(fulana.address!.zipCode)  // 70658192
        print(fulana.address!.city!)    // Brasilia
    }
}

struct Association1xN {
    static func execute() {
        let phone1 = Phone(ddd: 61, number: 998382934)
        let phone2 = Phone(ddd: 15, number: 838493302)
        let phone3 = Phone(ddd: 61, number: 110293994)

        var fulana = Person1(name: "Ana", phone: "61992839456", phones: [phone1, phone2])
        fulana.phones.append(phone3)

        print(fulana.name)  // Ana
        for phone in fulana.phones {
            print("(" + String(phone.ddd) + ")" + " " + String(phone.number))
        }
        // (61) 998382934
        // (15) 838493302
        // (61) 110293994
    }
}

struct AssociationNxM {
    static func execute() {
        // Vamos criar alguma pessoas
        var pedro = Person1(name: "Pedro")
        var paula = Person1(name: "Paula")
        var joao = Person1(name: "João")
        var marcos = Person1(name: "Marcos")
        var camila = Person1(name: "Camila")

        // Vamos criar alguns grupos
        let group1 = Group1(name: "Grupo A", people: [pedro, paula, joao])
        let group2 = Group1(name: "Grupo B", people: [marcos, camila])

        pedro.groups.append(group1)
        paula.groups.append(group1)
        joao.groups.append(group1)
        marcos.groups.append(group2)
        camila.groups.append(group2)

        print(group1.name + ":")
        for person in group1.people {
            print(person.name)
        }
        // Pedro
        // Paula
        // João

        print(camila.name + " grupos:")
        for group in camila.groups {
            print(group.name)
            print(group.people.map { $0.name })
        }
        // Grupo B
        // Marcos
        // Camila
    }
}

/// É um tipo de associação que indica todo-parte se o objeto morrer o objeto parte continuará existindo
struct Aggregation {
    static func execute() {
        // Os items existem independente do pedido
        let item1 = Item1(title: "XTudo", price: 11.90)
        let item2 = Item1(title: "Coca-Cola", price: 5.75)
        let item3 = Item1(title: "Batata Frita", price: 5.00)

        var order = Order1(items: [item1, item2, item3])
        print("O pedido ficou: R$ " + String(order.getBill()))
        // O pedido ficou: R$ 22.65
    }
}

/// É um tipo de associação que indica todo-parte na qual o objeto parte só pode pertencer a um único objeto todo,
/// se o objeto todo morrer, o objeto parte também morre.
struct Composition {
    static func execute() {
        // O notebook pode existir sem um teclado
        let notebook = Notebook(model: "HP")
        // O teclado não pode existir sem o notebook
        let keyboard = Keyboard(model: "Logitech", notebook: notebook)
        print("Keyboard: " + notebook.keyboard!.model)
        print("Notebook: " + keyboard.notebook.model)
    }
}
