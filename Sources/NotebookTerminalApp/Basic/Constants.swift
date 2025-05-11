// Vamos criar uma constantes com o struct

import AppKit

struct Constants {
    static let apiKey = "YOUR_API_KEY_HERE"
    struct Metadata {
        static let appName = "notebook"
        static let version = 1.0
    }
}

func constantsRunner() {
    print(Constants.apiKey)
    print(Constants.Metadata.version)
}
