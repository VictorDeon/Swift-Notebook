let CLOSURES = closureRunner
let DELEGATE = delegateRunner
let FUNCTIONS = functionRunner
let EXTENSIONS = extensionRunner
let PROTOCOLS = protocolRunner
let OPTIONALS = optionalRunner
let OO = objectOrientationRunner
let DICTIONARY = dictionaryRunner
let ARRAY = arrayRunner
let CONDITIONALS = conditionalRunner
let SCOPE = scopeRunner
let TYPES = typeRunner
let LOOPS = loopRunner
let RANDOM = randomRunner
let TIMER = timerRunnerAsync
let ENUMS = enumRunner
let THIRD_PARTY_LIBRARY = thirdPartyLibraryRunner

struct MyApp {
    static func run() async {
        await THIRD_PARTY_LIBRARY()
    }
}

await MyApp.run()
