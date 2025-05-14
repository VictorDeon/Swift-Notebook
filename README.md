## Notebook Swift

Aqui será registrados alguns algoritmos de swift para consulta rapida.

### Gerar o Binario/Pacote Swift com o Swift Package Manager (SPM)

```sh
// Execute o comando abaixo para gerar o Package.swift e a pasta Sources para inserir seu codigo.
// Esse pode ser um executable (binario) ou uma library (pacote de importação em outros projetos)
$ swift package init --type <executable|library>
// Modifica o Package.swift para incluir as dependencias, nome do seu binario e etc
// Mova seus *.swift para Sources/<NomeDoSeuBinario>/.
// Execute o comando abaixo para compilar e gerar o binario
$ swift build -c <debug|release> ou $ swift run
$ .build/<debug|release>/<NomeDoSeuBinario>
```

### Schemas do Swift

1. Entre em Product/Scheme/Manage Shemes
2. Adicione a quantidade de schemes que quiser com os parâmetros do terminal que desejar.
3. Modifique o scheme no editor para ao clicar em run executar o scheme que desejar.
// Lib de parametros de terminal: https://github.com/apple/swift-argument-parser

### IOS Lifecycle

#### ViewController Lifecycle

viewDidLoad -> viewWillAppear -> viewDidAppear, viewWillDisappear -> viewDidDisappear

#### App Lifecycle (AppDelegate.swift + SceneDelegate.swift + ViewControllers.swift)

Vamos ligar o app

1.  application(_:didFinishLaunchingWithOptions:)
2.  scene(_:willConnectTo:options:)
3.  ViewController1 viewDidLoad Called
4.  ViewController1 viewWillAppear Called
5.  sceneWillEnterForeground(_:)
6.  sceneDidBecomeActive(_:)
7.  ViewController1 viewDidAppear Called

Vamos para a proxima pagina

8.  ViewController2 viewDidLoad Called
9.  ViewController1 viewWillDisappear Called
10. ViewController2 viewWillAppear Called
11. ViewController2 viewDidAppear Called
12. ViewController1 viewDidDisappear Called

Voltando para a tela inicial

13. ViewController2 viewWillDisappear Called
14. ViewController1 viewWillAppear Called
15. ViewController1 viewDidAppear Called
16. ViewController2 viewDidDisappear Called

Vamos ir para a home page do celular ou só trocar de aplicativo (colocar o app em background)

17. sceneWillResignActive(_:)
18. sceneDidEnterBackground(_:)

Vamos voltar para o nosso aplicativo (colocar ele em foreground novamente)

19. sceneWillEnterForeground(_:)
20. scenedidBecomeActive(_:)

Agora vamos desligar o app

21. sceneWillResignActive(_:)
22. sceneDidDisconnect(_:)
23. application(_:didDiscardSceneSessions:)

### Versões

Macos 10.15
* xcode 11
* ios 13 (iPhone 6S ou maior, iPhone SE)
* iPad Air 2 ou later ou iPad mini 4

TODO:

- [x] Sintaxe basica, intermediaria e avançada
- [ ] Modulos
- [ ] Empacotamento e geração do binario
- [ ] Sistema de logging
- [ ] Lista de metodos uteis para cada tipo do swift
- [ ] Operações no Sistema Operacional do MACOS
- [ ] Manipulação de arquivos
	- [ ] JSON
	- [ ] CSV
	- [ ] PLIST
    - [ ] XML
- [ ] Finalizar OO
- [ ] Requisições HTTP
- [ ] Datetime
- [ ] Inputs e Outputs
- [x] Execução por Terminal com Path Parameters
- [ ] Firebase
    - [ ] Firebase Auth: Solução em nuvem de autenticação.
    - [ ] Firestore: Solução de banco de dados em nuvem NoSQL
- [ ] Design Patterns
    - [x] Delegate
    - [ ] Singleton
- [ ] SwiftUI
- [ ] Banco de Dados
    - [x] UserDefaults: Armazena pequenos bites de dados em plists, normalmente usado em configurações
    - [x] Codable (NSCoder): Armazena pequenos objetos em plists
    - [ ] Keychain: Armazena pequenos bites de dados de forma segura
    - [ ] SQLite: Persiste grandes quantidades de dados em banco relacional SQL (FMDB)
    - [x] Realm: Solução de banco de dados (framework) mais rapida e facil de usar.
- [ ] Assincronicidade igual ao python (Corotines)
- [ ] Regex
- [ ] Testes Automatizados
- [ ] Threads e Processos
- [ ] Libs da Apple
- [ ] Estrutura de Dados e Algoritmos
- [ ] Socket
- [ ] Criptografia e Segurança
- [ ] Machine Learning e Data Science
- [ ] Matematica
