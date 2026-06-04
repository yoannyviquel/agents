// Observer — subscription mechanism to notify subscribers of events.
#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

class Observer {
public:
    virtual ~Observer() = default;
    virtual void onNotify(int value) = 0;
};

class Subject {
    std::vector<Observer*> observers;
    int value = 0;
public:
    void subscribe(Observer* o) { observers.push_back(o); }
    void unsubscribe(Observer* o) {
        observers.erase(std::remove(observers.begin(), observers.end(), o), observers.end());
    }
    void setValue(int v) {
        value = v;
        for (auto* o : observers) o->onNotify(value);
    }
};

class Logger : public Observer {
    std::string name;
public:
    explicit Logger(std::string n) : name(std::move(n)) {}
    void onNotify(int value) override {
        std::cout << name << " observed value=" << value << "\n";
    }
};

int main() {
    Subject subject;
    Logger a{"A"}, b{"B"};
    subject.subscribe(&a);
    subject.subscribe(&b);

    subject.setValue(10);
    subject.unsubscribe(&a);
    subject.setValue(20);
    return 0;
}
