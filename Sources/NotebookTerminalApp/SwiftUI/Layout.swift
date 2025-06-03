/**
 O layoud do SwiftUI funciona perguntando a todas as suas views internas para determinar quanto de espaço cada uma vai ocupar no espaço de seu elemento pai.

As view `VStack`, `HStack` e `ZStack` são conhecidas como **Compound Views**, ou seja, ela se compoem de outras views.

 Ja as views `Rectangle` ou `Color` é conhecida como **Expanding View**, pois ela sempre tenta se expandir para o máximo de espaço possível na tela, só não preenhce as `Safe Areas` que são as areas que normalmente muda de celular em ceular.
 
 Temos também as **Hugging Views** que se expande seomente ao espaço que ela precisa. Por exemplo o `Text`.
 
 Temos uma intermediaria como a `Toogle` que se expande apenas a um dos lados, vertical ou horizontal.
 
 O posicionamento comum de qualquer view dentro de um container é **centralizado**.
 
 Podemos usar o GeometryReader caso queira criar o layout baseado no tamanho do celular de forma dinamica.
 */

import SwiftUI
import ArgumentParser
import VKSwiftUI

struct LayoutCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "layouts",
        abstract: "Layouts com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalSwiftUI.showWindow(VStackContent(), by: app)
            app.run()

            TerminalSwiftUI.showWindow(HStackContent(), by: app)
            app.run()
            
            TerminalSwiftUI.showWindow(ZStackContent(), by: app)
            app.run()
            
            TerminalSwiftUI.showWindow(LayoutContent(), by: app)
            app.run()
            
            TerminalSwiftUI.showWindow(AlignmentContent(), by: app)
            app.run()
            
            TerminalSwiftUI.showWindow(PositionContent(), by: app)
            app.run()
            
            TerminalSwiftUI.showWindow(GeometryContent(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct VStackContent: View {
    var body: some View {
        /// Todas as views dentro dessa stack vao ser alinhadas verticalmente
        VStack {
            Text("Hello 01")
            Text("Hello 02")
            Text("Hello 03")
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

fileprivate struct HStackContent: View {
    var body: some View {
        /// Todas as views dentro dessa stack vao se alinhadas horizontalmente
        HStack {
            Text("Hello 01")
            Text("Hello 02")
            Text("Hello 03")
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}

fileprivate struct ZStackContent: View {
    var body: some View {
        /// Todas as views dentro dessa stack vao ser alinhadas uma em cima da outra.
        ZStack {
            Text("Hello 01")
            Text("Hello 02")
            Text("Hello 03")
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}

fileprivate struct LayoutContent: View {
    var body: some View {
        /// Monta o background
        ZStack {
            Rectangle().fill(Color.purple).ignoresSafeArea()
            /// Cria o profile com a foto a esquerda e a msg a direita
            HStack {
                Image(systemName: "person.fill")
                /// Cria a mensagem na vertical
                VStack {
                    Text("Hello").foregroundColor(.white)
                    Text("World").foregroundColor(.white)
                }
            }
        }
        .frame(width: 300, height: 100)
    }
}

fileprivate struct AlignmentContent: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            /// O alinhamento ocorre no tamanho da stack e esse é do tamanho dos seus filhos, logo quem vai alinha é o texto em relação a foto.
            /// VStack alignment: .center, .leading (esquerda) e .trailing (direita)
            /// HStack alignment: .center, .top (cima) e .bottom (baixo)
            /// spacing é o espaçamento entre os elementos dentro da stack
            VStack(alignment: .center, spacing: 10) {
                if
                    let url = Bundle.module.url(forResource: "applepic", withExtension: "jpg"),
                    let nsImage = NSImage(contentsOf: url) {
                    Image(nsImage: nsImage)
                    Spacer()  // Preenche todo espaço disponivel entre a imagem o a maça
                    Text("Maça").foregroundColor(.black)
                } else {
                    Text("Imagem não encontrada").foregroundColor(.black)
                }
            }
            // O alinhamento do frame é relacionado ao VStack inteiro que esta sendo aplicado
            .frame(width: 300, height: 300, alignment: .center)
            // .padding(.top, 20), .padding(.leading, 20), .padding(.bottom, 20), .padding(.trailing, 20)
            // .padding(.vertical, 20), .padding(.horizontal, 20)
            // .padding([.top, .leading], 20)
            .padding(20)
        }
    }
}

fileprivate struct PositionContent: View {
    var body: some View {
        VStack {
            // Posicionamento absoluto em relação a tela x=0 e y=0 é o lateral esquerda superior.
            // O ponto de referencia do posicionamento das views é seu centro.
            Text("@")
                .position(x: 100, y: 100)
                .border(Color.white)
        }
        VStack {
            // Posicionamento relativo em relação ao seu pai x=0 e y =0 é o centro da view de seu pai
            // O ponto de referencia para esse caso é sempre o centro da view.
            Text("#")
                .offset(x: 10, y: 10)
                .border(Color.white)
        }
        .frame(width: 300, height: 300)
    }
}

fileprivate struct GeometryContent: View {
    var body: some View {
        GeometryReader { screen in
            VStack {
                HStack {
                    if
                        let url = Bundle.module.url(forResource: "applepic", withExtension: "jpg"),
                        let nsImage = NSImage(contentsOf: url) {
                        Image(nsImage: nsImage)
                            .frame(width: (screen.size.width - 20) / 2)
                            .border(Color.black)
                    } else {
                        Text("Imagem não encontrada").foregroundColor(.black)
                    }
                    Text("Maça")
                        .frame(width: (screen.size.width - 20) / 2)
                        .border(Color.black)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                Spacer()
            }
            .frame(width: screen.size.width)
            .border(Color.black)
        }
    }
}
