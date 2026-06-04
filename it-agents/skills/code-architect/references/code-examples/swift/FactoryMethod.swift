// Factory Method — subclasses decide which product class to instantiate via a factory method.

protocol Transport {
    func deliver() -> String
}

struct GroundUnit: Transport {
    func deliver() -> String { "carrying cargo by road" }
}

struct AirUnit: Transport {
    func deliver() -> String { "carrying cargo by air" }
}

// Creator declares the factory method; subclasses override it to choose a product.
class Dispatcher {
    func makeTransport() -> Transport {
        fatalError("subclass must override makeTransport()")
    }

    func runRoute() -> String {
        let transport = makeTransport()
        return "Dispatcher is " + transport.deliver()
    }
}

class RoadDispatcher: Dispatcher {
    override func makeTransport() -> Transport { GroundUnit() }
}

class SkyDispatcher: Dispatcher {
    override func makeTransport() -> Transport { AirUnit() }
}

func runDemo() {
    let dispatchers: [Dispatcher] = [RoadDispatcher(), SkyDispatcher()]
    for dispatcher in dispatchers {
        print(dispatcher.runRoute())
    }
}

runDemo()
