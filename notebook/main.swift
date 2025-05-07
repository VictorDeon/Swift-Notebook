let CLOSURES = closureRunner
let DELEGATE = delegateRunner

func execute(_ runner: () -> Void) {
    runner()
}

execute(CLOSURES)
