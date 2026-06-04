// Factory Method — subclasses decide which product class to instantiate via a factory method.
#include <iostream>
#include <memory>
#include <string>

// Product interface.
class Conveyance {
public:
    virtual ~Conveyance() = default;
    virtual std::string describe() const = 0;
};

class GroundUnit : public Conveyance {
public:
    std::string describe() const override { return "rolling ground unit"; }
};

class AirUnit : public Conveyance {
public:
    std::string describe() const override { return "lifting air unit"; }
};

// Creator declares the factory method.
class Dispatcher {
public:
    virtual ~Dispatcher() = default;
    virtual std::unique_ptr<Conveyance> make() const = 0;

    // Business logic relies on the product produced by the factory method.
    void deliver() const {
        auto unit = make();
        std::cout << "Dispatching via " << unit->describe() << ".\n";
    }
};

class GroundDispatcher : public Dispatcher {
public:
    std::unique_ptr<Conveyance> make() const override {
        return std::make_unique<GroundUnit>();
    }
};

class AirDispatcher : public Dispatcher {
public:
    std::unique_ptr<Conveyance> make() const override {
        return std::make_unique<AirUnit>();
    }
};

int main() {
    std::unique_ptr<Dispatcher> d1 = std::make_unique<GroundDispatcher>();
    std::unique_ptr<Dispatcher> d2 = std::make_unique<AirDispatcher>();
    d1->deliver();
    d2->deliver();
    return 0;
}
