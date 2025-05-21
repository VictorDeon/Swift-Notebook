import AppKit
import ArgumentParser

struct POPCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "pop",
        abstract: "Tutorial sobre orientacão a protocolo em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        let celta = Celta(brand: "Chevrolet")
        celta.start()
        celta.stop()
        
        var cars: [VehicleProtocol] = []
        cars.append(celta)
        print(cars.count)
    }
}

protocol VehicleProtocol {
    var description: String { get }
    var brand: String { get }
    init(brand: String)
    func start()
    func stop()
}

extension VehicleProtocol {
    func getBrand() -> String {
        return brand
    }
}

protocol EngineProtocol {
    var hasFuel: Bool { get }
    var isServiced: Bool { get }
}

struct Engine: EngineProtocol {
    var hasFuel: Bool = true
    var isServiced: Bool = false
}

struct Celta: VehicleProtocol {
    var description: String {
        return getBrand()
    }

    var engine: Engine
    
    let brand: String
    
    init(brand: String) {
        self.brand = brand
        self.engine = Engine()
    }
    
    init(brand: String, engine: Engine) {
        self.brand = brand
        self.engine = engine
    }
    
    func start() {
        print("Ligando o motor do celta.")
    }
    
    func stop() {
        print("Parando o motor do celta.")
    }
}

struct AirPlane {
    var engine: Engine
    
    init(engine: Engine) {
        self.engine = engine
    }
}
