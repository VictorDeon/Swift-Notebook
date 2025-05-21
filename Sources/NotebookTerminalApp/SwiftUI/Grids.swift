import SwiftUI
import ArgumentParser

struct GridsCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "grids",
        abstract: "Grids com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(HorizontalStack(), by: app, title: "Horizontal Stack")
            app.run()
            
            TerminalApp.showWindow(VerticalStack(), by: app, title: "Vertical Stack")
            app.run()
            
            TerminalApp.showWindow(GridsContentView(), by: app, title: "Grids")
            app.run()
 
            TerminalApp.showWindow(LazyVGridsFlexibleContentView(), by: app, title: "Lazy V Flexible Grids")
            app.run()
            
            TerminalApp.showWindow(LazyVGridsAdaptativeContentView(), by: app, title: "Lazy V Adaptative Grids")
            app.run()

            TerminalApp.showWindow(LazyHGridsContentView(), by: app, title: "Lazy H Grids")
            app.run()

            print("Finalizado!")
        }
    }
}

/// alignment: define o alinhamento vertical dos elementos.
/// spacing: distância fixa entre os elementos.
/// Spacer(): preenche o espaço disponível, como um flex-grow.
/// .justify-content-start: Stack {  conteudo + Spacer() }
/// .justify-content-end: Stack {  Spacer() + conteudo }
/// .justify-content-center: Stack { Spacer() + conteudo + Spacer() }
/// .justify-content-between: Stack { conteudo + Spacer() + conteudo  }
fileprivate struct HorizontalStack: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("Item 1")
            Text("Item 2")
            Spacer()                   // empurra itens para as extremidades
            Text("Item 3")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

/// .frame(maxHeight: .infinity) faz o VStack expandir-se, permitindo que o Spacer() “empurre” conteúdos.
fileprivate struct VerticalStack: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Título").font(.title)
            Text("Subtítulo mais longo que quebra linha se necessário.")
            Spacer()
            Button("Ação") { /*…*/ }
        }
        .frame(width: 300, height: 300)   // VStack preenche todo o espaço vertical
        .padding(30)
    }
}

fileprivate struct GridsContentView: View {
    var body: some View {
        VStack(spacing: 15) {
            Grid(horizontalSpacing: 0, verticalSpacing: 5) {
                GridRow {
                    Color.gray
                    Color.gray
                    Color.gray
                }
                GridRow(alignment: .center) {
                    Color.brown
                        .frame(width: 50, height: 50)
                        .gridColumnAlignment(.trailing)
                    Spacer()
                    Color.brown
                        .frame(width: 50, height: 50)
                        .gridColumnAlignment(.trailing)
                }
                GridRow(alignment: .top) {
                    Color.gray
                    Color.brown
                        .frame(height: 100)
                    Color.gray
                }
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

/// Para um numero largo de dados ou dados dinamicos utilize o GridLazy ao inves do Grid por questão de performace
/// GridItem(.flexible()…): cada coluna se ajusta igualmente (flex).
fileprivate struct LazyVGridsFlexibleContentView: View {
    
    // Definimos 3 colunas flexíveis, como col-4 col-4 col-4
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<12) { i in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 100)
                        .overlay(Text("\(i)").foregroundColor(.white))
                }
            }
            .padding(16)   // equivalente ao .container do Bootstrap
        }.frame(width: 300, height: 300, alignment: .center)
    }
}

/// GridItem(.adaptive(minimum: 100)): cria quantas colunas couberem, com largura ≥ 100pt (similar a col-auto/responsive).
fileprivate struct LazyVGridsAdaptativeContentView: View {
    
    // Definimos 3 colunas flexíveis, como col-4 col-4 col-4
    let adaptiveCols = [ GridItem(.adaptive(minimum: 120), spacing: 12) ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveCols, spacing: 16) {
                ForEach(0..<12) { i in
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 100)
                        .overlay(Text("\(i)").foregroundColor(.white))
                }
            }
            .padding(16)   // equivalente ao .container do Bootstrap
        }.frame(width: 300, height: 300, alignment: .center)
    }
}

/// fixed type grid: Cria colunas ou linhas com tamanho fixo (largura para V e altura para H)
fileprivate struct LazyHGridsContentView: View {
    
    let rows: [GridItem] = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        ScrollView {
            LazyHGrid(rows: rows) {
                ForEach(1...9, id: \.self) { index in
                    Color.red
                        .frame(width: 50)
                }
            }
        }
        .padding(10)
        .frame(width: 300, height: 300, alignment: .center)
    }
}
