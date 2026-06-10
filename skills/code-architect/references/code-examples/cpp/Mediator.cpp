// Mediator — centralize communication between components.
#include <iostream>
#include <string>
#include <vector>

class Mediator;

// Colleague base knows only the mediator.
class Participant {
protected:
    Mediator* mediator = nullptr;
    std::string name;
public:
    explicit Participant(std::string n) : name(std::move(n)) {}
    virtual ~Participant() = default;
    void setMediator(Mediator* m) { mediator = m; }
    const std::string& id() const { return name; }
    virtual void receive(const std::string& from, const std::string& msg) {
        std::cout << name << " got from " << from << ": " << msg << "\n";
    }
    void send(const std::string& msg);
};

class Mediator {
    std::vector<Participant*> members;
public:
    void registerMember(Participant* p) {
        members.push_back(p);
        p->setMediator(this);
    }
    void broadcast(Participant* sender, const std::string& msg) {
        for (auto* m : members)
            if (m != sender) m->receive(sender->id(), msg);
    }
};

void Participant::send(const std::string& msg) {
    if (mediator) mediator->broadcast(this, msg);
}

int main() {
    Mediator hub;
    Participant a{"A"}, b{"B"}, c{"C"};
    hub.registerMember(&a);
    hub.registerMember(&b);
    hub.registerMember(&c);

    a.send("hello everyone");
    return 0;
}
