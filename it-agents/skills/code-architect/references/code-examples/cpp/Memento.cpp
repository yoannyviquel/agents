// Memento — capture and restore an object's state without breaking encapsulation.
#include <iostream>
#include <stack>
#include <string>

// Memento stores an opaque snapshot; only the Originator reads it.
class Memento {
    friend class Editor;
    std::string state;
    explicit Memento(std::string s) : state(std::move(s)) {}
};

// Originator.
class Editor {
    std::string buffer;
public:
    void type(const std::string& s) { buffer += s; }
    const std::string& text() const { return buffer; }

    Memento save() const { return Memento{buffer}; }
    void restore(const Memento& m) { buffer = m.state; }
};

// Caretaker keeps mementos without inspecting them.
class History {
    std::stack<Memento> snapshots;
public:
    void push(const Memento& m) { snapshots.push(m); }
    Memento pop() {
        Memento m = snapshots.top();
        snapshots.pop();
        return m;
    }
    bool empty() const { return snapshots.empty(); }
};

int main() {
    Editor editor;
    History history;

    editor.type("alpha");
    history.push(editor.save());
    editor.type("-beta");
    std::cout << "current: " << editor.text() << "\n";

    editor.restore(history.pop());
    std::cout << "restored: " << editor.text() << "\n";
    return 0;
}
