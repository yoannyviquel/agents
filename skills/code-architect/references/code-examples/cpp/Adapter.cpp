// Adapter — make an incompatible interface usable via a wrapper.
#include <iostream>
#include <memory>
#include <string>

// Target interface the client expects.
class Endpoint {
public:
    virtual ~Endpoint() = default;
    virtual std::string send(const std::string& payload) const = 0;
};

// Incompatible existing service with a different signature.
class LegacyService {
public:
    std::string transmit(const std::string& blob, int channel) const {
        return "legacy[ch" + std::to_string(channel) + "]:" + blob;
    }
};

// Adapter makes LegacyService usable through the Endpoint interface.
class LegacyAdapter : public Endpoint {
    LegacyService service;
    int channel;
public:
    explicit LegacyAdapter(int ch) : channel(ch) {}
    std::string send(const std::string& payload) const override {
        return service.transmit(payload, channel);
    }
};

void client(const Endpoint& e) {
    std::cout << e.send("hello") << "\n";
}

int main() {
    LegacyAdapter adapter{7};
    client(adapter);
    return 0;
}
