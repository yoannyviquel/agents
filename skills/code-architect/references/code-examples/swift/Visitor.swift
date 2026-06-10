// Visitor — separate algorithms from objects via accept/visit (double dispatch).

protocol Visitor {
    func visit(_ node: NumberNode)
    func visit(_ node: TextNode)
}

protocol Element {
    func accept(_ visitor: Visitor)
}

struct NumberNode: Element {
    let value: Double
    func accept(_ visitor: Visitor) { visitor.visit(self) }
}

struct TextNode: Element {
    let value: String
    func accept(_ visitor: Visitor) { visitor.visit(self) }
}

// A concrete visitor implements one algorithm over all element types.
final class DescribeVisitor: Visitor {
    private(set) var output: [String] = []

    func visit(_ node: NumberNode) {
        output.append("number(\(node.value))")
    }

    func visit(_ node: TextNode) {
        output.append("text(\"\(node.value)\")")
    }
}

func runDemo() {
    let elements: [Element] = [
        NumberNode(value: 3.14),
        TextNode(value: "hi"),
        NumberNode(value: 42)
    ]

    let describer = DescribeVisitor()
    elements.forEach { $0.accept(describer) }
    describer.output.forEach { print($0) }
}

runDemo()
