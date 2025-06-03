import SwiftUI
import ArgumentParser
import VKSwiftUI

struct ImageCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "images",
        abstract: "Imagens com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            
            TerminalSwiftUI.showWindow(ImageContent(), by: app)
            app.run()
            
            TerminalSwiftUI.showWindow(BigImageContent(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct ImageContent: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                if
                    /// Em ferramentas CLI temos que especificar a pasta Assets dentro de resources no Package.swift
                    let url = Bundle.module.url(forResource: "applepic", withExtension: "jpg"),
                    let nsImage = NSImage(contentsOf: url) {
                    Image(nsImage: nsImage)
                        // Expande a imagem o máximo que conseguir
                        .resizable()
                        // Encaixe perfeitamente no frame abaixo sem perder muito a qualidade da imagem
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .border(Color.black)
                } else {
                    Text("Imagem não encontrada").foregroundColor(.black)
                }
            }
            // O alinhamento do frame é relacionado ao VStack inteiro que esta sendo aplicado
            .frame(width: 300, height: 300, alignment: .center)
            .padding(20)
        }
    }
}

fileprivate struct BigImageContent: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                if
                    /// Em ferramentas CLI temos que especificar a pasta Assets dentro de resources no Package.swift
                    let url = Bundle.module.url(forResource: "tree", withExtension: "jpg"),
                    let nsImage = NSImage(contentsOf: url) {
                    Image(nsImage: nsImage)
                        // Expande a imagem o máximo que conseguir
                        .resizable()
                        // Seta o max width o tamanho maximo da janela
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                    Spacer()
                } else {
                    Text("Imagem não encontrada").foregroundColor(.black)
                }
            }
            // O alinhamento do frame é relacionado ao VStack inteiro que esta sendo aplicado
            .frame(width: 300, height: 300, alignment: .center)
        }
    }
}
