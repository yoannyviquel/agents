// Command — encapsulate a request as an object, support undo.

// Receiver holds the actual state.
final class Counter {
    private(set) var value = 0
    func add(_ amount: Int) { value += amount }
    func subtract(_ amount: Int) { value -= amount }
}

protocol Command {
    func execute()
    func undo()
}

struct AddCommand: Command {
    let counter: Counter
    let amount: Int
    func execute() { counter.add(amount) }
    func undo() { counter.subtract(amount) }
}

// Invoker keeps a history for undo.
final class Invoker {
    private var history: [Command] = []

    func run(_ command: Command) {
        command.execute()
        history.append(command)
    }

    func undoLast() {
        guard let last = history.popLast() else { return }
        last.undo()
    }
}

func runDemo() {
    let counter = Counter()
    let invoker = Invoker()

    invoker.run(AddCommand(counter: counter, amount: 5))
    invoker.run(AddCommand(counter: counter, amount: 3))
    print("after two adds:", counter.value)

    invoker.undoLast()
    print("after undo:", counter.value)
}

runDemo()
