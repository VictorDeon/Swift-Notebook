// Classes = Passagem por referência, ou seja, o proprio objeto.
// Struct = Passagem por valor, ou seja, uma copia.
// Classes = Pode ter herança e implementar protocolos.
// Struct = Não pode haver herança, mas pode implementar protocolos.
// Classes = Mutable (pode mudar seus valores sem problema)
// Struct = Immutable (não é possível modificar seus valores internamente sem usar o mutating)

class Enemy {
    // Atributos
    var health: Int
    var atkStrength: Int
    
    // Construtor
    init(health: Int, atk: Int = 10) {
        self.health = health
        self.atkStrength = atk
    }
    
    // Metodos
    func move() {
        print("Monstro se movendo...")
    }
    
    func attack() {
        print("Monstro atacando e dando \(atkStrength) de dano.")
    }
    
    func takeDamage(amount: Int) {
        print("Monstro tomou dano de \(amount)")
        health -= amount
    }
}

class Dragon: Enemy {
    // Atributo de instancia
    var wingSpan: Int = 2
    // Atributo de classe
    static let eat: String = "Hora do rango"

    // Metodo de instancia
    func talk(speech: String) {
        print("Dragão diz: \(speech)")
    }
    
    // Método de classe
    static func sing() {
        print("Um rango legal, é o que precisamos...")
    }

    // sobrecarga
    func attack(strength: Int) {
        print("Dragão atacando com dano \(strength)")
    }

    // sobrescrita
    override func move() {
        print("Dragão voaando")
    }
}

struct Goblin {
    var health: Int
    var atkStrength: Int

    // Construtor
    init(health: Int, atk: Int = 10) {
        self.health = health
        self.atkStrength = atk
    }
    
    // Metodos
    func move() {
        print("Goblin struct se movendo...")
    }
    
    func attack() {
        print("Goblin struct atacando e dando \(atkStrength) de dano.")
    }
    
    // Precisa inserir o mutating para poder modificar seus valores internamente
    mutating func takeDamage(amount: Int) {
        print("goblin struct Tomou dano de \(amount)")
        health -= amount
    }
}


func objectOrientationRunner() async {
    let skeleton1 = Enemy(health: 100)
    print("Esqueleto 01 = Vida: \(skeleton1.health)")   // Esqueleto 01 = Vide: 100
    print(skeleton1.move())                             // Monstro se movendo..
    print(skeleton1.attack())                           // Monstro atacando e dando 10 de dano
    
    let skeleton2 = Enemy(health: 100)
    print("Esqueleto 02 = Vida: \(skeleton2.health)")   // Esqueleto 02 = Vida: 100
    skeleton2.takeDamage(amount: skeleton1.atkStrength) // Monstro tomou dano de 10
    print("Esqueleto 02 = Vida: \(skeleton2.health)")   // Esqueleto 02 = Vide: 90
    
    var goblin = Goblin(health: 150, atk: 20)
    print("Goblin = Vida: \(goblin.health)")            // Goblin = Vida: 150
    goblin.takeDamage(amount: skeleton1.atkStrength)    // Goblin struct tomou dano de 10
    print("Goblin = Vida: \(goblin.health)")            // Goblin = Vida: 140
    
    let dragon = Dragon(health: 1000)
    // Dragão = Vida: 1000 e quantidade de asas: 2
    print("Dragão = Vida: \(dragon.health) e quantidade de asas: \(dragon.wingSpan)")
    print(dragon.move())                        // Dragão voaando
    print(dragon.talk(speech: "Graaaa...."))    // Dragão diz: Graaaa...
    print(dragon.attack())                      // Monstro atacando e dando 10 de dano
    print(dragon.attack(strength: 100))         // Dragão atacando com dano 100
    print(Dragon.eat)                           // Hora do rango
    print(Dragon.sing())                        // Um rango legal, é o que precisamos...
}
