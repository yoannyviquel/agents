// Mediator — centralize communication between components.

protocol Mediator: AnyObject {
    func notify(sender: Component, event: String)
}

class Component {
    weak var mediator: Mediator?
    let id: String
    init(id: String) { self.id = id }
}

final class Publisher: Component {
    func publish(_ event: String) {
        print("\(id) publishes '\(event)'")
        mediator?.notify(sender: self, event: event)
    }
}

final class Subscriber: Component {
    func receive(_ event: String) {
        print("\(id) received '\(event)'")
    }
}

// Mediator wires senders to receivers; components stay decoupled.
final class EventHub: Mediator {
    private var subscribers: [Subscriber] = []

    func register(_ subscriber: Subscriber) {
        subscriber.mediator = self
        subscribers.append(subscriber)
    }

    func register(_ publisher: Publisher) {
        publisher.mediator = self
    }

    func notify(sender: Component, event: String) {
        guard sender is Publisher else { return }
        subscribers.forEach { $0.receive(event) }
    }
}

func runDemo() {
    let hub = EventHub()
    let publisher = Publisher(id: "P1")
    hub.register(publisher)
    hub.register(Subscriber(id: "S1"))
    hub.register(Subscriber(id: "S2"))

    publisher.publish("config-changed")
}

runDemo()
