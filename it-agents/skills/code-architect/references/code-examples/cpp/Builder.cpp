// Builder — construct complex objects step by step.
#include <iostream>
#include <memory>
#include <string>
#include <vector>

// The complex product.
struct Assembly {
    std::string frame;
    std::vector<std::string> modules;
    void show() const {
        std::cout << "Assembly[frame=" << frame << ", modules=";
        for (size_t i = 0; i < modules.size(); ++i)
            std::cout << modules[i] << (i + 1 < modules.size() ? "," : "");
        std::cout << "]\n";
    }
};

// Builder interface.
class AssemblyBuilder {
public:
    virtual ~AssemblyBuilder() = default;
    virtual void reset() = 0;
    virtual void setFrame() = 0;
    virtual void addModule() = 0;
    virtual Assembly result() = 0;
};

class StandardBuilder : public AssemblyBuilder {
    Assembly product;
public:
    StandardBuilder() { reset(); }
    void reset() override { product = Assembly{}; }
    void setFrame() override { product.frame = "steel"; }
    void addModule() override { product.modules.push_back("standard-module"); }
    Assembly result() override {
        Assembly out = std::move(product);
        reset();
        return out;
    }
};

// Director encodes a known construction sequence.
class Director {
public:
    Assembly buildMinimal(AssemblyBuilder& b) {
        b.reset();
        b.setFrame();
        return b.result();
    }
    Assembly buildFull(AssemblyBuilder& b) {
        b.reset();
        b.setFrame();
        b.addModule();
        b.addModule();
        return b.result();
    }
};

int main() {
    StandardBuilder builder;
    Director director;
    director.buildMinimal(builder).show();
    director.buildFull(builder).show();
    return 0;
}
