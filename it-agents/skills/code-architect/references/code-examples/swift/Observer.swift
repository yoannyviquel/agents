// Observer — subscription mechanism to notify subscribers of events.

protocol Observer: AnyObject {
    func update(value: Int)
}

final class Subject {
    private var observers: [Observer] = []
    private var value = 0 {
        didSet { notify() }
    }

    func subscribe(_ observer: Observer) {
        observers.append(observer)
    }

    func setValue(_ newValue: Int) {
        value = newValue
    }

    private func notify() {
        observers.forEach { $0.update(value: value) }
    }
}

final class LoggingObserver: Observer {
    let name: String
    init(name: String) { self.name = name }
    func update(value: Int) {
        print("\(name) saw new value: \(value)")
    }
}

func runDemo() {
    let subject = Subject()
    subject.subscribe(LoggingObserver(name: "A"))
    subject.subscribe(LoggingObserver(name: "B"))

    subject.setValue(10)
    subject.setValue(42)
}

runDemo()
