// Facade — a simplified interface over a complex subsystem.
#include <iostream>
#include <string>

// Subsystem components, each with its own concerns.
class Loader {
public:
    std::string load(const std::string& id) const { return "data<" + id + ">"; }
};

class Validator {
public:
    bool check(const std::string& data) const { return !data.empty(); }
};

class Renderer {
public:
    std::string render(const std::string& data) const { return "[ " + data + " ]"; }
};

// Facade orchestrates the subsystem behind one method.
class ViewFacade {
    Loader loader;
    Validator validator;
    Renderer renderer;
public:
    std::string open(const std::string& id) const {
        auto data = loader.load(id);
        if (!validator.check(data)) return "<invalid>";
        return renderer.render(data);
    }
};

int main() {
    ViewFacade facade;
    std::cout << facade.open("42") << "\n";
    return 0;
}
