// Proxy — a placeholder controlling access to a real object (lazy/caching).
#include <iostream>
#include <memory>
#include <string>

// Common interface.
class Resource {
public:
    virtual ~Resource() = default;
    virtual std::string fetch() = 0;
};

// Expensive real subject.
class HeavyResource : public Resource {
    std::string payload;
public:
    HeavyResource() {
        std::cout << "(building heavy resource...)\n";
        payload = "heavy-payload";
    }
    std::string fetch() override { return payload; }
};

// Proxy: lazy construction + caching.
class ResourceProxy : public Resource {
    std::unique_ptr<HeavyResource> real;
    std::string cache;
    bool cached = false;
public:
    std::string fetch() override {
        if (!real) real = std::make_unique<HeavyResource>();
        if (!cached) {
            cache = real->fetch();
            cached = true;
        } else {
            std::cout << "(served from cache)\n";
        }
        return cache;
    }
};

int main() {
    ResourceProxy proxy;
    std::cout << "before first access\n";
    std::cout << proxy.fetch() << "\n";
    std::cout << proxy.fetch() << "\n";
    return 0;
}
