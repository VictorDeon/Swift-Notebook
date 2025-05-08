let CLOSURES = closureRunner
let DELEGATE = delegateRunner
let FUNCTIONS = functionRunner
let EXTENSIONS = extensionRunner
let PROTOCOLS = protocolRunner

func execute(_ runner: () -> Void) {
    runner()
}

execute(PROTOCOLS)
