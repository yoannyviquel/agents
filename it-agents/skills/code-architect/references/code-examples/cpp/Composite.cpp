// Composite — compose objects into trees, treat leaf and container uniformly.
#include <iostream>
#include <memory>
#include <string>
#include <vector>

class Node {
public:
    virtual ~Node() = default;
    virtual int weight() const = 0;
    virtual void print(int depth = 0) const = 0;
protected:
    static void indent(int depth) {
        for (int i = 0; i < depth; ++i) std::cout << "  ";
    }
};

// Leaf.
class Item : public Node {
    std::string name;
    int w;
public:
    Item(std::string n, int weight) : name(std::move(n)), w(weight) {}
    int weight() const override { return w; }
    void print(int depth = 0) const override {
        indent(depth);
        std::cout << "- " << name << " (" << w << ")\n";
    }
};

// Composite.
class Group : public Node {
    std::string name;
    std::vector<std::shared_ptr<Node>> children;
public:
    explicit Group(std::string n) : name(std::move(n)) {}
    void add(std::shared_ptr<Node> child) { children.push_back(std::move(child)); }
    int weight() const override {
        int total = 0;
        for (const auto& c : children) total += c->weight();
        return total;
    }
    void print(int depth = 0) const override {
        indent(depth);
        std::cout << "+ " << name << " (" << weight() << ")\n";
        for (const auto& c : children) c->print(depth + 1);
    }
};

int main() {
    auto root = std::make_shared<Group>("root");
    auto sub = std::make_shared<Group>("sub");
    sub->add(std::make_shared<Item>("a", 3));
    sub->add(std::make_shared<Item>("b", 4));
    root->add(sub);
    root->add(std::make_shared<Item>("c", 5));

    root->print();
    std::cout << "total weight = " << root->weight() << "\n";
    return 0;
}
