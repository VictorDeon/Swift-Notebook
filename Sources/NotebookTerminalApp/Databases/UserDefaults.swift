// Usado para armazenar poucos dados em um plist dentro do SO, muito usado para armazenar preferencias do sistema
// ou do usuario, não use para armazenar array, dicionario ou objetos pq ele não é performatico.
// por baixo dos panos usa a API CFPreferences, no macos todos os defaults da sua aplicação vão para:
// /Users/<username>/Library/Preferences/<bundle>.plist ou <PackageName>.plist
// Para ler o plist utilize: $ defaults read <bundle> ou <PackageName>

import AppKit
import ArgumentParser

struct UserDefaultCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "user-defaults",
        abstract: "Tutorial sobre user defaults plist store em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        // Usado para encontrar a pasta de documentos do usuario no SO do macos ou do iphone
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        // /Users/<username>/Documents
        userDefaultRunner()
    }
}

func userDefaultRunner() {
    let defaults = UserDefaults.standard
    defaults.set(0.24, forKey: "Volume")
    defaults.set(true, forKey: "MusicOn")
    defaults.set("Victor", forKey: "PlayerName")
    defaults.set(Date(), forKey: "AppLastOpenedByUser")

    let volume = defaults.float(forKey: "Volume")
    print("volume = \(volume)")  // volume = 0.24

    let isMusicOn = defaults.bool(forKey: "MusicOn")
    print("music on? \(isMusicOn)") // music on? true

    let playerName = defaults.string(forKey: "PlayerName")!
    print("player = \(playerName)") // player = Victor

    let appLastOpenedByUser = defaults.object(forKey: "AppLastOpenedByUser") as? Date
    print("app last opened by user = \(appLastOpenedByUser!)") // app last opened by user = 2025-05-12 15:48:40 +0000

    let array = [1, 2, 3, 4, 5]
    defaults.set(array, forKey: "musicIds")
    let musicIds = defaults.array(forKey: "musicIds") as? [Int] ?? []
    print(musicIds) // [1, 2, 3, 4, 5]

    let dictionary: [String: Any] = ["name": "Victor", "age": 31]
    defaults.set(dictionary, forKey: "playerData")
    print(defaults.dictionary(forKey: "playerData")!) // ["age": 31, "name": Victor]

    defaults.removeObject(forKey: "playerData")
}
