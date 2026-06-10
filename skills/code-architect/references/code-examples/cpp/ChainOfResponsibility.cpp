// Chain of Responsibility — pass a request along a chain of handlers.
#include <iostream>
#include <memory>
#include <string>

class Handler {
protected:
    std::shared_ptr<Handler> next;
public:
    virtual ~Handler() = default;
    std::shared_ptr<Handler> setNext(std::shared_ptr<Handler> h) {
        next = h;
        return h; // allow fluent chaining
    }
    virtual void handle(int level, const std::string& msg) {
        if (next) next->handle(level, msg);
        else std::cout << "[unhandled] " << msg << "\n";
    }
};

class InfoHandler : public Handler {
public:
    void handle(int level, const std::string& msg) override {
        if (level <= 1) std::cout << "[info] " << msg << "\n";
        else Handler::handle(level, msg);
    }
};

class WarnHandler : public Handler {
public:
    void handle(int level, const std::string& msg) override {
        if (level == 2) std::cout << "[warn] " << msg << "\n";
        else Handler::handle(level, msg);
    }
};

class ErrorHandler : public Handler {
public:
    void handle(int level, const std::string& msg) override {
        if (level >= 3) std::cout << "[error] " << msg << "\n";
        else Handler::handle(level, msg);
    }
};

int main() {
    auto info = std::make_shared<InfoHandler>();
    auto warn = std::make_shared<WarnHandler>();
    auto error = std::make_shared<ErrorHandler>();
    info->setNext(warn)->setNext(error);

    info->handle(1, "starting up");
    info->handle(2, "low memory");
    info->handle(3, "crash");
    info->handle(9, "unknown level");
    return 0;
}
