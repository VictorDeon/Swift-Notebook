// swift-tools-version: 6.0
// O swift-tools-version declara a versão mínima do Swift necessária para compilar este pacote.
/**
 1. name: String = Nome do pacote (Obrigatorio)
 2. defaultLocalization: String = Local padrão para recursos. Ex: en
 3. platforms: [Platform] = Plataformas e versões mínimas (iOS, macOS, etc).
 4. products: [Product] = Produtos que este pacote exporta (bibliotecas, executáveis, plugins).
 5. dependencies: [Package.Dependency] = Outros pacotes de que este depende
 6. targets: [Target] = Conjunto de módulos e testes que formam o pacote. (Obrigatório)
 7. swiftLanguageVersions: [SwiftVersion] = Versões de Swift suportadas.
 8. cLanguageStandard: CLanguageStandard = Padrão C adotado (.gnu11, .c11).
 9. cxxLanguageStandard: CXXLanguageStandard = Padrão C++ adotado (.gnucxx14, .cxx17).

 platforms: Define em quais plataformas (e suas versões mínimas) seu pacote pode rodar.
 ```swift
 platforms: [
   .iOS(.v13),
   .macOS(.v12),
   .tvOS(.v14),
   .watchOS(.v7),
   .macCatalyst(.v14)
 ]
 ```

 products: Cada produto pode ser biblioteca, executável ou plugin
 ```swift
 .library(
   name: "MinhaLib",
   type: .dynamic,                          // .static | .dynamic | .automatic
   targets: ["MeuTarget"]
 )
 .executable(
   name: "MeuAppCLI",
   targets: ["MeuTarget"]
 )
 .plugin(
   name: "MeuPlugin",
   capability: .buildTool(),               // ou .command(...)
   dependencies: []
 )
 ```

 dependencies: Dependencias da sua aplicação
 ```swift
 dependencies: [
   .package(url: "https://…/Repo.git", from: "1.2.0"),  // significa >= e < próxima quebra de major.
   .package(url: "https://…/X.git", .exact("2.3.1")),   // exatamente aquela versão.
   .package(url: "https://…/Y.git", .upToNextMajor(from: "4.5.0")),  // mesmo que from
   .package(url: "https://…/Z.git", .upToNextMinor(from: "0.9.0")),  // permite correções de patch, mas não minor/major.
   .package(url: "https://…/W.git", .branch("develop")),  // usa uma branch específica.
   .package(url: "https://…/V.git", .revision("a1b2c3d")) // usa um commit específico.
 ]
 ```

 targets: Os targets são os “módulos” do seu pacote. Existem quatro tipos principais
 1. .target (biblioteca ou código comum)
 2. .executableTarget (gera executável)
 3. .testTarget (testes)
 4. .plugin (extensão de build, lint, etc)
 Todos compartilham parâmetros similares:
 1. name: String = Nome do target.
 2. dependencies: [Target.Dependency] = Alvos ou produtos de outros pacotes.
 3. path: String = Caminho customizado para o código-fonte.
 4. exclude: [String] = Arquivos/pastas a excluir.
 5. sources: [String] = Arquivos-fonte específicos.
 6. publicHeadersPath: String = Para código C/C++.
 7. resources: [Resource] = Dados que embarcam no bundle.
 8. cSettings: [CSetting]  =  Flags para compilador C.
 9. cxxSettings    [CXXSetting]  = Flags para compilador C++.
 10. swiftSettings    [SwiftSetting] =  Flags Swift, defines, unsafeFlags.
 11. linkerSettings    [LinkerSetting] =  Flags para o linker.

 resources: Dados que embarcam no bundle.
 ```swift
   .process("Assets/my-*.xcassets"),  // serão compilados/otimizados
   .copy("Data/config.json")       // copiados “às cegas”
 ```
*/

import PackageDescription

let package = Package(
    name: "NotebookTerminalApp",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "7.5.0"),
        .package(url: "https://github.com/realm/realm-swift.git", .upToNextMajor(from: "20.0.2")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/Kitura/Swift-JWT.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "NotebookTerminalApp",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SwiftJWT", package: "Swift-JWT")
            ],
            resources: [
                .process("version.txt")
            ]
        )
    ]
)
