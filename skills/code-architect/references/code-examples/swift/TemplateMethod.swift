// Template Method — algorithm skeleton in a base class with overridable steps.

class DataExporter {
    // The template method defines the fixed sequence of steps.
    final func export() -> String {
        let header = makeHeader()
        let body = makeBody()
        return header + "\n" + body
    }

    func makeHeader() -> String { fatalError("override makeHeader()") }
    func makeBody() -> String { fatalError("override makeBody()") }
}

final class CSVExporter: DataExporter {
    override func makeHeader() -> String { "id,name" }
    override func makeBody() -> String { "1,Ada\n2,Lin" }
}

final class MarkdownExporter: DataExporter {
    override func makeHeader() -> String { "| id | name |" }
    override func makeBody() -> String { "| 1 | Ada |\n| 2 | Lin |" }
}

func runDemo() {
    print("CSV:")
    print(CSVExporter().export())
    print("\nMarkdown:")
    print(MarkdownExporter().export())
}

runDemo()
