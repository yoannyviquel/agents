// Command — encapsulate a request as an object, support undo.
#include <iostream>
#include <memory>
#include <stack>
#include <string>
#include <vector>

// Receiver holds the state operated on.
class Document {
    std::string text;
public:
    void append(const std::string& s) { text += s; }
    void erase(size_t n) { text.erase(text.size() - n); }
    const std::string& content() const { return text; }
};

// Command interface.
class Command {
public:
    virtual ~Command() = default;
    virtual void execute() = 0;
    virtual void undo() = 0;
};

class AppendCommand : public Command {
    Document& doc;
    std::string fragment;
public:
    AppendCommand(Document& d, std::string s) : doc(d), fragment(std::move(s)) {}
    void execute() override { doc.append(fragment); }
    void undo() override { doc.erase(fragment.size()); }
};

// Invoker keeps a history for undo.
class Invoker {
    std::stack<std::unique_ptr<Command>> history;
public:
    void run(std::unique_ptr<Command> cmd) {
        cmd->execute();
        history.push(std::move(cmd));
    }
    void undo() {
        if (history.empty()) return;
        history.top()->undo();
        history.pop();
    }
};

int main() {
    Document doc;
    Invoker invoker;
    invoker.run(std::make_unique<AppendCommand>(doc, "Hello"));
    invoker.run(std::make_unique<AppendCommand>(doc, ", World"));
    std::cout << doc.content() << "\n";
    invoker.undo();
    std::cout << doc.content() << "\n";
    return 0;
}
