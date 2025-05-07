let CLOSURES = closureRunner
let DELEGATE = delegateRunner
let FUNCTIONS = functionRunner

func execute(_ runner: () -> Void) {
    runner()
}

execute(FUNCTIONS)
