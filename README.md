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

### Uso do CocoaPod

Adicionando libs externas usando o Cocoapods

Vamos instalar e usas essa lib: https://github.com/Alamofire/Alamofire

Doc: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#making-requests

Instale o cocopod pelo terminal:
```sh
$ sudo gem install cocoapods
$ pod setup --verbose
```

Instale todas as dependencias que o cocoapods pedir, caso precise

Ao finalizar a instação vamos confirmar que ta tudo certo com o comando:

```sh
$ pod --version
```

Va até o diretorio onde o arquivo .xcodeproj do seu projeto está e execute o comando para criar o Podfile:

```sh
$ pod init
```

Faça a integração do Alamofire no cocopod a partir do arquivo Podfile

```Podfile
pod 'Alamofire'
```


Rode o comando:

```sh
$ pod install
```

Agora saia da sessão que vc estas do xcode e utilize o .xcworkspace para abrir uma nova sessão.

Para saber se a lib é compativel com seu PodFile olhe o arquivo .podspec do github deles, olhe a versão
e a platform que é compativel

Para atualizar as libs do seu PodFile execute o comando:

```sh
$ pod update
```

Se quiser remover alguma lib do PodFile é só remover ela do arquivo e executar o `$ pod install`

Com isso vamos poder usar a lib

Para adicionar usando o **Packages do xcode** é bem mais simples só adicionar as informações necessarias
disponibilizada pela lib dentro do `Package.swift` e automaticamente a lib sera inserida.

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
- [ ] Empacotamento de modulos e utilização do pacote
- [ ] Geração do binario via github actions
- [ ] Sistema de logging
- [x] Lista de metodos uteis para cada tipo do swift
- [ ] Operações no Sistema Operacional do MACOS
- [ ] Manipulação de arquivos
	- [ ] JSON
	- [ ] CSV
    - [ ] Excel
    - [ ] PDF
	- [ ] PLIST
    - [ ] XML
- [x] Finalizar OO
- [ ] Requisições HTTP
- [ ] Datetime
- [ ] Inputs e Outputs
- [x] Execução por Terminal com Path Parameters
- [ ] Firebase
    - [ ] Firebase Auth: Solução em nuvem de autenticação.
    - [ ] Firestore: Solução de banco de dados em nuvem NoSQL
    - [ ] Storage: Armazenamento de arquivos
    - [ ] Analytics
    - [ ] Crashlytics
    - [ ] A/B Testing
- [ ] Design Patterns
    - [x] Delegate
    - [x] Singleton
    - [ ] Chain Of Responsability
    - [ ] Command
    - [ ] Interpreter
    - [ ] Iterator
    - [ ] Mediator
    - [ ] Observer
    - [ ] Memento
    - [ ] State
    - [ ] Strategy
    - [ ] Template Method
    - [ ] Visitor
    - [ ] Abstract Factory
    - [ ] Builder
    - [ ] Factory Method
    - [ ] Multiton
    - [ ] Object Pool
    - [ ] Prototype
    - [ ] Adapter
    - [ ] Bridge
    - [ ] Composite
    - [ ] Decorator
    - [ ] Facade
    - [ ] Flyweight
    - [ ] Proxy
- [ ] SwiftUI
- [x] Banco de Dados
    - [x] UserDefaults: Armazena pequenos bites de dados em plists, normalmente usado em configurações
    - [x] Codable (NSCoder): Armazena pequenos objetos em plists
    - [x] Keychain: Armazena pequenos bites de dados de forma segura
    - [x] SQLite: Persiste grandes quantidades de dados em banco relacional SQL (FMDB)
    - [x] Realm: Solução de banco de dados (framework) mais rapida e facil de usar.
- [ ] Assincronicidade igual ao python (Corotines)
- [ ] Regex
- [ ] Testes Automatizados
- [ ] Threads e Processos
- [ ] Libs da Apple
- [ ] Estrutura de Dados (pacotes)
    - [ ] Pilha
    - [ ] Fila
    - [ ] Deque
    - [ ] Lista Encadeada
    - [ ] Lista Duplamente Encadeada
    - [ ] Fila de Prioridades
    - [ ] Binary Heap
    - [ ] Tabela Hash
    - [ ] Grafos
    - [ ] Matriz de Adjacencia
    - [ ] Lista de Adjacencia
    - [ ] Matriz de Incidencia
    - [ ] Lista de Incidencia
- [ ] Algoritmos (pacotes)
    - [ ] Analise Assintótica
    - [ ] Arvore Binária de Busca
    - [ ] Busca em Profundidade
    - [ ] Busca em Largura
    - [ ] Programação Dinamica
    - [ ] Algoritmo Guloso
    - [ ] Algoritmo de Dijkstra
    - [ ] Detectando Ciclos em Grafos
    - [ ] Backtracking
    - [ ] Algoritmos de Ordenação
        - [ ] Bubble Sort
        - [ ] Selection Sort
        - [ ] Insertion Sort
        - [ ] Quick Sort
        - [ ] Merge Sort
    - [ ] Função Sort
    - [ ] Caixante Viajeiro
    - [ ] Busca Tabu
    - [ ] Busca Binaria
    - [ ] Distancia Hamming
    - [ ] Distancia de Edicao
    - [ ] Cifra de Cesar
    - [ ] Simulated Annealing
- [ ] Socket
- [ ] Criptografia e Segurança
- [ ] Machine Learning e Data Science
- [ ] Matematica
