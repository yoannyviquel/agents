// Bridge — split abstraction and implementation into independent hierarchies.
#include <iostream>
#include <memory>
#include <string>

// Implementation hierarchy.
class Backend {
public:
    virtual ~Backend() = default;
    virtual std::string emit(const std::string& msg) const = 0;
};

class ConsoleBackend : public Backend {
public:
    std::string emit(const std::string& msg) const override { return "[console] " + msg; }
};

class FileBackend : public Backend {
public:
    std::string emit(const std::string& msg) const override { return "[file] " + msg; }
};

// Abstraction holds a reference to an implementation.
class Reporter {
protected:
    std::shared_ptr<Backend> backend;
public:
    explicit Reporter(std::shared_ptr<Backend> b) : backend(std::move(b)) {}
    virtual ~Reporter() = default;
    virtual void report(const std::string& text) const = 0;
};

// Refined abstraction.
class PlainReporter : public Reporter {
public:
    using Reporter::Reporter;
    void report(const std::string& text) const override {
        std::cout << backend->emit(text) << "\n";
    }
};

class UrgentReporter : public Reporter {
public:
    using Reporter::Reporter;
    void report(const std::string& text) const override {
        std::cout << backend->emit("!! " + text + " !!") << "\n";
    }
};

int main() {
    auto console = std::make_shared<ConsoleBackend>();
    auto file = std::make_shared<FileBackend>();

    PlainReporter{console}.report("startup ok");
    UrgentReporter{file}.report("disk low");
    return 0;
}
