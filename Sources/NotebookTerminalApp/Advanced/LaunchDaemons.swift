/**
 1. O que é o Launch Daemon (launchd)
    * launchd é o init do macOS: o processo mestre que inicia e gerencia todos os serviços de sistema e de usuário.
    * Um Launch Daemon é um “serviço” que roda como root (nível de sistema), sem interface gráfica,
      sempre ativo conforme você configurar.
    *  Arquivos de configuração são plists (Property Lists) em XML.
 
 2. Locais típicos de instalação
    1. Sistema (todos usuários): /Library/LaunchDaemons/
    2. Sistema protegido (não modifique!): /System/Library/LaunchDaemons/
    3. Per-user (agentes, não daemons): ~/Library/LaunchAgents/
 
 3. Estrutura básica de um plist
 ```plist
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
     "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
     <key>Label</key>
     <string>com.exemplo.meudaemon</string>
     <key>ProgramArguments</key>
     <array>
         <string>/usr/local/bin/meu-binarion</string>
         <string>--modo=worker</string>
     </array>
     <key>RunAtLoad</key>
     <true/>
     <key>KeepAlive</key>
     <true/>
 </dict>
 </plist>
 ```
 
4. Principais chaves / parâmetros
 |Chave|Tipo|O que faz|
 |---------|-----|--------------|
 |Label|String|Identificador único (ex. com.empresa.serviço)|
 |Program|String|Caminho do executável sem argumentos|
 |ProgramArguments|Array String|Caminho do executável + argumentos. Ex: [executavel, arg1, arg2, ...]|
 |RunAtLoad|Boolean|Executa assim que o daemon é carregado|
 |KeepAlive|Boolean/Dict|Se True ele reinicia sempre ou um dict para condições avançadas|
 |StartInterval|Integer|Intervalo em segundos entre execuções periodicas|
 |StartCalendarInterval|Dict/Array|Agenda tipo calendário (hora, minuto, dia do mês) igual a um cronjob)|
 |StartOnMount|Boolean|Dispara ao montar volume|Utils para backups em disco externo|
 |WorkingDirectory|String|Pasta onde o daemon vai correr|
 |ThrottleInterval|Integer|Tempo mínimo (segundos) entre reinícios automáticos que ocorre no KeepAlive|
 |UserName/GroupName|String|Rodar sob outro usuario/grupo|
 |EnvironmentVariables|Dict|Variáveis de ambiente para o processo|
 |StandardOutPath e StandardErrorPath   |String|Arquivos de log para stdout e stderr|
 |Socket|String|Configura sockets UNIX ou TCP para abertura de conexões por launchd|
 |MachServices|String|Expões serviços Mach IPC aos clientes|
 |WatchPaths/QueueDirectories|String| Dispara quando arquivos em pasta mudam|
 |LaunchEvents|String|Responde a eventos do sistema ex. conexão de rede|
 
 5. Carregando e descarregando: launchctl
 ```sh
 # Carregar ou recarregar (se já existir)
 sudo launchctl bootstrap system /Library/LaunchDaemons/tech.vksoftware.notebookdaemon.plist

 # Descarregar
 sudo launchctl bootout system /Library/LaunchDaemons/tech.vksoftware.notebookdaemon.plist

 # Listar todos os daemons carregados
 launchctl list | grep tech.vksoftware

 # Verifica o que tem dentro do launch loaded
 launchctl print system/tech.vksoftware.notebookdaemon

 # Ler os logs
 tail -f /var/log/swiftdaemon.{out,err}.log

 # Validar o plist
 plutil -lint /Library/LaunchDaemons/tech.vksoftware.notebookdaemon.plist
 ```
 
 6. Casos:
    1. Quero executar somente uma vez ao dar load: utilize o RunAtLoad = true
    2. Quero executar toda vez a cada 2 minutos: utilize o KeepAlive(true) + ThrottleInterval(120) ou StartInterval(120)
    3. Quero executar somente uma vez apos 30 segundos: utilize o RunAtLoad = true com sleep de 30 segundos no script,
      ou StartInterval(30) com unload apos a primeira execução dentro do script bash
        
*/

import Foundation
import ArgumentParser

struct LaunchDaemonCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "launch-daemon",
        abstract: "Tutorial sobre launch daemon em swift"
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .long,
        help: "Caminho para o executavel"
    )
    var executable: String

    @Option(
        name: .long,
        parsing: .upToNextOption,
        help: "Argumentos de array para o executavel (separados por espaços) e com aspas duplas"
    )
    var arguments: [String]

    func run() throws {
        LaunchDaemonEmSwift.run(executable, arguments)
    }
}

/// Como criar e gerenciar Launch Daemons em Swift
/// Você pode usar Swift para gerar, instalar e carregar um plist automaticamente
/// Permissão: gravar em /Library/LaunchDaemons exige sudo.
/// Erros: trate exceções de I/O e de Process para feedback ao usuário.
/// Ao atualizar o plist, faça primeiro sudo launchctl unload … antes de load.
/// Para remover, basta apagar o .plist e descarregar com launchctl unload.
fileprivate struct LaunchDaemonEmSwift {
    static func run(_ executable: String, _ arguments: [String]) {
        // 1. Monte o dicionário com as chaves
        let daemonConfig: [String: Any] = [
            "Label": "tech.vksoftware.notebookdaemon",
            "ProgramArguments": [executable] + arguments,
            "UserName": "root",
            "RunAtLoad": true,
            "KeepAlive": false,
            "EnvironmentVariables": [
                "PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            ],
            "StandardOutPath": "/var/log/swiftdaemon.out.log",
            "StandardErrorPath": "/var/log/swiftdaemon.err.log"
        ]

        let path = "/Library/LaunchDaemons/tech.vksoftware.notebookdaemon.plist"

        do {
            // 2. Serialize para XML plist
            let plistData = try PropertyListSerialization.data(
                fromPropertyList: daemonConfig,
                format: .xml,
                options: 0
            )

            // 3. Caminho onde vai ser escrito (requer permissão de root)
            try plistData.write(to: URL(fileURLWithPath: path))

            // 4. Carrega com launchctl
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            task.arguments = ["bootstrap", "system", path]
            try task.run()
            task.waitUntilExit()

            print("Launch Daemon instalado e carregado com código Swift!")
        } catch {
            print("Deu ruim \(error)")
        }
    }
}
