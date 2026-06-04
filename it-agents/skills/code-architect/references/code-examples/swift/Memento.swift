// Memento — capture and restore an object's state without breaking encapsulation.

// Opaque snapshot; only the originator knows how to read it.
struct EditorMemento {
    fileprivate let content: String
    fileprivate let cursor: Int
}

final class Editor {
    private var content = ""
    private var cursor = 0

    func type(_ text: String) {
        content += text
        cursor = content.count
    }

    func snapshot() -> EditorMemento {
        EditorMemento(content: content, cursor: cursor)
    }

    func restore(_ memento: EditorMemento) {
        content = memento.content
        cursor = memento.cursor
    }

    var state: String { "\"\(content)\" (cursor: \(cursor))" }
}

// Caretaker stores mementos without inspecting them.
final class History {
    private var stack: [EditorMemento] = []
    func save(_ memento: EditorMemento) { stack.append(memento) }
    func pop() -> EditorMemento? { stack.popLast() }
}

func runDemo() {
    let editor = Editor()
    let history = History()

    editor.type("Hello")
    history.save(editor.snapshot())
    editor.type(", world")
    print("current:", editor.state)

    if let saved = history.pop() {
        editor.restore(saved)
    }
    print("restored:", editor.state)
}

runDemo()
