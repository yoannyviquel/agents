// State — let an object alter behavior when its state changes (state objects).
#include <iostream>
#include <memory>
#include <string>

class Machine;

// State interface.
class State {
public:
    virtual ~State() = default;
    virtual void push(Machine& m) = 0;
    virtual std::string name() const = 0;
};

class Machine {
    std::unique_ptr<State> state;
public:
    explicit Machine(std::unique_ptr<State> initial) : state(std::move(initial)) {}
    void setState(std::unique_ptr<State> s) { state = std::move(s); }
    void push() { state->push(*this); }
    std::string current() const { return state->name(); }
};

// Forward declarations resolved below.
class Idle; class Running; class Paused;

class Idle : public State {
public:
    void push(Machine& m) override;
    std::string name() const override { return "Idle"; }
};
class Running : public State {
public:
    void push(Machine& m) override;
    std::string name() const override { return "Running"; }
};
class Paused : public State {
public:
    void push(Machine& m) override;
    std::string name() const override { return "Paused"; }
};

void Idle::push(Machine& m)    { m.setState(std::make_unique<Running>()); }
void Running::push(Machine& m) { m.setState(std::make_unique<Paused>()); }
void Paused::push(Machine& m)  { m.setState(std::make_unique<Idle>()); }

int main() {
    Machine machine{std::make_unique<Idle>()};
    for (int i = 0; i < 4; ++i) {
        std::cout << "state: " << machine.current() << "\n";
        machine.push();
    }
    return 0;
}
