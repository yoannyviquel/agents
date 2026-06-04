// Template Method — algorithm skeleton in a base class with overridable steps.
#include <iostream>
#include <string>

// Base class defines the invariant skeleton and abstract steps.
class Importer {
public:
    virtual ~Importer() = default;

    // The template method: fixed sequence, customizable steps.
    void process(const std::string& source) {
        auto raw = read(source);
        auto parsed = parse(raw);
        store(parsed);
        hook();
    }

protected:
    virtual std::string read(const std::string& source) {
        return "<bytes of " + source + ">";
    }
    virtual std::string parse(const std::string& raw) = 0; // required step
    virtual void store(const std::string& parsed) {
        std::cout << "stored: " << parsed << "\n";
    }
    virtual void hook() {} // optional step with default no-op
};

class CsvImporter : public Importer {
protected:
    std::string parse(const std::string& raw) override { return "csv{" + raw + "}"; }
};

class JsonImporter : public Importer {
protected:
    std::string parse(const std::string& raw) override { return "json{" + raw + "}"; }
    void hook() override { std::cout << "json import audited\n"; }
};

int main() {
    CsvImporter{}.process("table.csv");
    JsonImporter{}.process("payload.json");
    return 0;
}
