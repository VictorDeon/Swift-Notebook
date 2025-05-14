/*
 O problema: ciclo de referência (retain cycle)
    - Objetos “mantêm” uns aos outros na memória: se A guarda uma referência para B e B guarda uma
      referência para A, nenhum dos dois é liberado, mesmo que você não use mais nenhum deles.
    - No mundo das closures, isso acontece porque a closure captura (captures) o self de quem a criou,
      segurando o objeto com força.
 Imagine duas pessoas de mãos dadas o tempo todo — nenhuma delas consegue ir embora.
 Por que isso é importante?
    1. Apps iOS usam muita memória. Se objetos não forem liberados, o iPhone começa a ficar lento ou até mata seu app.
    2. Sempre que você guarda uma closure em uma propriedade de um objeto, pense: “Será que essa closure
       captura self e pode causar ciclo?”
 Resumo rápido:
    Problema: closure forte segura self → objeto nunca é liberado.
    Solução: use [weak self] na captura da closure.
    Efeito: self vira opcional, cycle evitado e memória é liberada corretamente.
 Assim você evita “vazamentos” de memória e mantém seu app saudável!
*/


import AppKit
import ArgumentParser
import Foundation

struct CicloDeReferenciaCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "reference-cycle",
        abstract: "Tutorial sobre ciclo de referencia em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        runLeakyExample()
        // Ana está executando a tarefa (Leaky).
        // Referência externa a PessoaLeaky zerada.

        // Uma espera curta para garantir ordem de prints
        Thread.sleep(forTimeInterval: 1)

        runSafeExample()
        // Bruno está executando a tarefa (Safe).
        // Referência externa a PessoaSafe zerada.
        // PessoaSafe Bruno foi desalocada.

        // Mais uma espera para ver tudo antes de sair
        Thread.sleep(forTimeInterval: 1)
    }
}

// Quando você cria Pessoa(nome: "Ana"), dentro de init a closure guarda self (ou seja, a própria Ana).
// Agora Pessoa guarda a closure, e a closure guarda a Pessoa → ciclo → “fuga” impossível.
class PessoaLeaky {
    var nome: String
    // Uma closure que pode usar 'self'
    var tarefa: (() -> Void)?

    init(nome: String) {
        self.nome = nome
        // Aqui, a closure captura 'self' com força:
        tarefa = {
            print("\(self.nome) está executando a tarefa")
        }
    }
    
    deinit {
        print("PessoaLeaky \(nome) foi desalocada.")
    }
}

// A solução: captura fraca ([weak self])
// [weak self] diz: “Dentro desta closure, não prendo self de verdade. Se não houver ninguém mais usando o objeto,
// ele pode ser desalocado normalmente.”
// A closure passa a ter self como opcional (self? ou guard let), porque ele pode já ter sido liberado.
class PessoaSafe {
    var nome: String
    var tarefa: (() -> Void)?

    init(nome: String) {
        self.nome = nome
        // Captura fraca: a closure não "segura" o self com força
        tarefa = { [weak self] in
            // 'self' vira opcional: pode ser nil se o objeto já tiver sido liberado
            guard let s = self else { return }
            print("\(s.nome) está executando a tarefa")
        }
    }
    
    deinit {
        print("PessoaSafe \(nome) foi desalocada.")
    }
}

func runLeakyExample() {
    print("→ Iniciando exemplo LEAKY")
    var pessoa: PessoaLeaky? = PessoaLeaky(nome: "Ana")
    pessoa?.tarefa?()
    // Em seguida, zeramos a referência externa
    pessoa = nil
    print("Referência externa a PessoaLeaky zerada.\n")
    // Aqui não veremos o deinit, pois há retain cycle
}

func runSafeExample() {
    print("→ Iniciando exemplo SAFE")
    var pessoa: PessoaSafe? = PessoaSafe(nome: "Bruno")
    pessoa?.tarefa?()
    // Em seguida, zeramos a referência externa
    pessoa = nil
    print("Referência externa a PessoaSafe zerada.\n")
    // Agora sim o deinit será chamado, porque não há retain cycle
}

