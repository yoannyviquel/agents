// Visitor — separate algorithms from objects via accept/visit (double dispatch).
#include <iostream>
#include <memory>
#include <string>
#include <vector>

class Circle;
class Square;

// Visitor interface declares a visit per concrete element.
class Visitor {
public:
    virtual ~Visitor() = default;
    virtual void visit(const Circle& c) = 0;
    virtual void visit(const Square& s) = 0;
};

class Element {
public:
    virtual ~Element() = default;
    virtual void accept(Visitor& v) const = 0;
};

class Circle : public Element {
public:
    double radius;
    explicit Circle(double r) : radius(r) {}
    void accept(Visitor& v) const override { v.visit(*this); }
};

class Square : public Element {
public:
    double side;
    explicit Square(double s) : side(s) {}
    void accept(Visitor& v) const override { v.visit(*this); }
};

// Concrete visitor implements one algorithm across all element types.
class AreaVisitor : public Visitor {
public:
    void visit(const Circle& c) override {
        std::cout << "circle area = " << 3.14159 * c.radius * c.radius << "\n";
    }
    void visit(const Square& s) override {
        std::cout << "square area = " << s.side * s.side << "\n";
    }
};

int main() {
    std::vector<std::unique_ptr<Element>> shapes;
    shapes.push_back(std::make_unique<Circle>(2.0));
    shapes.push_back(std::make_unique<Square>(3.0));

    AreaVisitor visitor;
    for (const auto& shape : shapes) shape->accept(visitor);
    return 0;
}
