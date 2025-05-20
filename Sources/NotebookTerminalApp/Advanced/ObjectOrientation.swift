/*
 Em Swift, podemos aplicar os princípios de Orientação a Objetos (OO) para organizar e estruturar melhor nosso código.
 Os quatro pilares clássicos de OO são:
    1. Encapsulamento – agrupar dados e comportamentos em uma mesma unidade (classe/struct) e controlar o acesso a eles.
    2. Abstração – expor apenas o que é relevante, escondendo detalhes de implementação.
    3. Herança – criar hierarquias de tipos para reutilizar e especializar comportamento.
    4. Polimorfismo – permitir que diferentes tipos sejam tratados de forma uniforme, geralmente via PROTOCOLOS.
    5. Protocol - Em OO também é conhecido como Interface.
 Além disso, em Swift:
    - Classes são passadas por referência e podem herdar de outras classes.
    - Structs são passadas por valor, mais leves e seguras, mas não suportam herança de implementação.
    - Protocolos definem contratos (métodos/propriedades) sem fornecer implementação — viabilizam o polimorfismo.
 Pontos-Chave de OO em Swift:
    1. Encapsulamento: use private/fileprivate para esconder detalhes.
    2. Abstração: exponha apenas interfaces (protocolos) e hide implementações.
    3. Herança: classes suportam herança simples; structs não.
    4. Polimorfismo: protocole-oriented programming facilita o uso de múltiplas hierarquias.
    5. Value vs Reference: structs (valor) são copiados; classes (referência) compartilham instância.
    6. Final Classes: use final para impedir novas heranças quando desejar imutabilidade de design.
    7. Computed Properties e Property Observers podem coexistir para enriquecer comportamento de seus modelos
    8. Classe Abstrata: Não é implementado por padrai em swift, mas você pode criar um Protocol e usa o Extension
        para colocar um fatalError("funcaoXYZ() precisa ser implementado pela subclasse")
 Controle de Acesso (Access Control):
    - open:     É visivel em qualquer módulo, e permite subclass & override, usado em bibliotecas públicas que
                querem ser extensíveis.
    - public:   É visivel em qualquer módulo, mas não permite override fora, usado em APIs públicas somente
                leitura da herança
    - internal: É visivel dentro do mesmo módulo (padrão), usado em código do app ou framework.
    - fileprivate: É visivel apenas neste arquivo Swift, usado para agrupar tipos relacionados no mesmo arquivo
    - private:  É visivel apenas no escopo da declaração, usado para esconder detalhes dentro de uma classe/struct
*/

import AppKit
import ArgumentParser

struct OOCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "oo",
        abstract: "Tutorial sobre orientação a objetos em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        OORunner().execute()
    }
}

// MARK: 1. Modelagem de Personagens
// 1.1 Protocolos e Encapsulamento
// Definimos dois protocolos para reforçar abstração e polimorfismo:
/// Contrato para quem pode atacar
protocol Attackable {
    var health: Int { get set }
    func attack() -> Int
    mutating func takeDamage(_ amount: Int)
}

/// Contrato para quem pode se mover
protocol Movable {
    func move()
}

/// Classe Abstrata que só classes podem usar (protocol + extension = abstract class)
protocol Game: AnyObject {
    func attack()
    func move()
}
/// Extensão a classe abstrata
extension Game {
    func attack() {
        fatalError("attack() precisa ser implementado pela subclasse")
    }
    func move() {
        fatalError("move() precisa ser implementado pela subclasse")
    }
}

// 1.2 Classe Base: Character
// Usamos uma classe para demonstrar passagem por referência, herança e encapsulamento:
class GameCharacter: Attackable, Movable, Game {
    // público para leitura, privado para escrita
    private(set) var name: String             // name é read-only fora da classe
    var health: Int

    init(name: String, health: Int) {
        self.name = name
        self.health = health
    }

    // Computed Property para ver % de vida
    var healthPercentage: Double {
        return Double(health) / 100.0 * 100.0
    }

    // Attackable
    func attack() -> Int {
        // implementação genérica, subclasses podem sobrescrever
        return 5
    }

    func takeDamage(_ amount: Int) {
        health = max(health - amount, 0)
        print("\(name) tomou \(amount) de dano. Vida agora: \(health).")
    }

    // Movable
    func move() {
        print("\(name) se move.")
    }
}

/// Equatable cria uma comparação customizada
/// char1 = GameCharacter(health: 100)
/// char2 = GameCharacter(health: 200)
/// char1 == char2 ? false
extension GameCharacter: Equatable {
    static func == (lhs: GameCharacter, rhs: GameCharacter) -> Bool {
        return lhs.health == rhs.health
    }
}

// MARK: 2. Herança e Especialização
// 2.1 Inimigo Genérico: Enemy
class Enemy: GameCharacter {
    private var attackStrength: Int

    init(name: String, health: Int = 100, attackStrength: Int = 10) {
        self.attackStrength = attackStrength
        super.init(name: name, health: health)
    }

    override func attack() -> Int {
        print("\(name) ataca causando \(attackStrength) de dano.")
        return attackStrength
    }

    override func move() {
        print("\(name) se arrasta pelo chão.")
    }
}

// 2.2 Inimigo Especial: Dragon
final class Dragon: Enemy {
    let wingSpan: Int

    init(name: String, health: Int = 300, attackStrength: Int = 50, wingSpan: Int = 5) {
        self.wingSpan = wingSpan
        super.init(name: name, health: health, attackStrength: attackStrength)
    }

    // Sobrecarga de método
    func attack(withFire intensity: Int) -> Int {
        let damage = intensity * 2
        print("\(name) cospe fogo e causa \(damage) de dano.")
        return damage
    }

    // Sobrescrita de comportamento de movimento
    override func move() {
        print("\(name) voa majestoso com envergadura de \(wingSpan)m.")
    }

    // Método de classe
    static func roar() {
        print("🗣️ Dragões rugem para anunciar seu poder!")
    }
}

// MARK: 3. Value Type: Struct Goblin
// Para comparar, um Goblin como struct — passagem por valor e necessidade de mutating para mutar estado
struct Goblin: Attackable, Movable {
    var name: String
    var health: Int
    var attackStrength: Int

    func attack() -> Int {
        print("\(name) ataca com clava e causa \(attackStrength) de dano.")
        return attackStrength
    }

    mutating func takeDamage(_ amount: Int) {
        health = max(health - amount, 0)
        print("\(name) recebeu \(amount) de dano. Vida: \(health).")
    }

    func move() {
        print("\(name) corre entre as rochas.")
    }
}

// MARK: 4. Demonstração de Polimorfismo
// No OORunner, usamos arrays de Attackable e Movable para mostrar tratamento uniforme:
struct OORunner {
    func execute() {
        // Instâncias
        let skeleton = Enemy(name: "Esqueleto")
        let goblin = Goblin(name: "Goblin", health: 60, attackStrength: 8)
        let dragon = Dragon(name: "Drako", wingSpan: 7)

        // Polimorfismo: trate todos como Attackable
        let combatants: [Attackable] = [skeleton, goblin, dragon]
        print("\n--- Início do Combate ---")
        for var char in combatants {
            let damage = char.attack()
            // todos podem takeDamage; goblin precisa ser var
            char.takeDamage(damage / 2)
        }
        // --- Início do Combate ---
        // Esqueleto ataca causando 10 de dano.
        // Esqueleto tomou 5 de dano. Vida agora: 95.
        // Goblin ataca com clava e causa 8 de dano.
        // Goblin recebeu 4 de dano. Vida: 56.
        // Drako ataca causando 50 de dano.
        // Drako tomou 25 de dano. Vida agora: 275.

        // Movimentação genérica
        print("\n--- Movimentação ---")
        let movers: [Movable] = [skeleton, goblin, dragon]
        movers.forEach { $0.move() }
        // --- Movimentação ---
        // Esqueleto se arrasta pelo chão.
        // Goblin corre entre as rochas.
        // Drako voa majestoso com envergadura de 7m.

        // Comerciando métodos específicos
        print("\n--- Habilidades Específicas ---")
        _ = dragon.attack(withFire: 20)
        Dragon.roar()
        // --- Habilidades Específicas ---
        // Drako cospe fogo e causa 40 de dano.
        // 🗣️ Dragões rugem para anunciar seu poder!

        // Mostrar referência vs valor
        print("\n--- Referência vs Valor ---")
        let enemyCopy = skeleton
        enemyCopy.takeDamage(20)
        print("Esqueleto original agora tem \(skeleton.health) de vida (referência)")
        // Esqueleto tomou 20 de dano. Vida agora: 75.
        // Esqueleto original agora tem 75 de vida (referência)

        var goblinCopy = goblin
        goblinCopy.takeDamage(10)
        print("Goblin original tem \(goblin.health) (valor imutado)")
        // Goblin recebeu 10 de dano. Vida: 46.
        // Goblin original tem 56 (valor imutado)
    }
}
