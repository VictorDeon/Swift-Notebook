// Vamos criar uma constantes com o struct

struct Constants {
    static let apiKey = "YOUR_API_KEY_HERE"
    struct Metadata {
        static let appName = "notebook"
        static let version = 1.0
    }
}

func constantsRunner() async {
    print(Constants.apiKey)
    print(Constants.Metadata.version)
}
