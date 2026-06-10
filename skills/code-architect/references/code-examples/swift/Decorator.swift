// Decorator — attach responsibilities by wrapping objects at runtime.

protocol Message {
    func render() -> String
}

struct PlainMessage: Message {
    let text: String
    func render() -> String { text }
}

// Base decorator wraps another Message.
class MessageDecorator: Message {
    private let wrapped: Message
    init(_ wrapped: Message) { self.wrapped = wrapped }
    func render() -> String { wrapped.render() }
}

final class QuotedDecorator: MessageDecorator {
    override func render() -> String { "\"\(super.render())\"" }
}

final class ExclaimDecorator: MessageDecorator {
    override func render() -> String { super.render() + "!" }
}

func runDemo() {
    let base: Message = PlainMessage(text: "hello")
    print(base.render())

    let decorated = ExclaimDecorator(QuotedDecorator(base))
    print(decorated.render())
}

runDemo()
