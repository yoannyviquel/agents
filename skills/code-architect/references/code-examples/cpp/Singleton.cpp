// Singleton — ensure one instance with a global access point.
#include <iostream>
#include <string>

class Registry {
public:
    // Meyers singleton: thread-safe lazy init in C++11+.
    static Registry& instance() {
        static Registry inst;
        return inst;
    }

    Registry(const Registry&) = delete;
    Registry& operator=(const Registry&) = delete;

    void set(const std::string& value) { state = value; }
    const std::string& get() const { return state; }
    int touches() const { return count; }
    void touch() { ++count; }

private:
    Registry() = default;
    std::string state = "<empty>";
    int count = 0;
};

int main() {
    Registry::instance().set("configured");
    Registry::instance().touch();
    Registry::instance().touch();

    // Same object everywhere.
    std::cout << "value=" << Registry::instance().get()
              << " touches=" << Registry::instance().touches() << "\n";
    std::cout << "same instance: "
              << (&Registry::instance() == &Registry::instance() ? "yes" : "no") << "\n";
    return 0;
}
