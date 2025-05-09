import AppKit

struct Apps {
    static let SWIFT_UI_ENABLED: Bool = true

    struct basic {
        static let array = arrayRunner
        static let conditionals = conditionalRunner
        static let constants = constantsRunner
        static let dictionary = dictionaryRunner
        static let enums = enumRunner
        static let loops = loopRunner
        static let scope = scopeRunner
        static let types = typeRunner
    }
    struct intermediary {
        static let exceptions = extensionRunner
        static let functions = functionRunner
        static let optionals = optionalRunner
        static let randoms = randomRunner
    }
    struct advanced {
        static let casting = castingRunner
        static let closures = closureRunner
        static let extensions = extensionRunner
        static let oo = objectOrientationRunner
        static let protocols = protocolRunner
    }
    struct designPatterns {
        static let delegate = delegateRunner
    }
    struct library {
        static let timer = timerRunnerAsync
        static let thirdPartyLibrary = thirdPartyLibraryRunner
    }
    struct ui {
        static let hello_world = swiftUIHelloWorldRunner
    }
    
    static func run() async {
        await self.library.thirdPartyLibrary()
    }
    
    @MainActor static func run(_ app: NSApplication) {
        self.ui.hello_world(app)
    }
}
