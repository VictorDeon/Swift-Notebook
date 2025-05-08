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

func execute(_ runner: () -> Void) -> Void {
    runner()
}

execute(RANDOM)
