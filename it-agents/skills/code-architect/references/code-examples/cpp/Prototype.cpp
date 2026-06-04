// Prototype — copy existing objects via a clone interface without coupling to classes.
#include <iostream>
#include <memory>
#include <string>

class Shape {
protected:
    std::string label;
    int weight = 0;
public:
    virtual ~Shape() = default;
    Shape() = default;
    Shape(std::string l, int w) : label(std::move(l)), weight(w) {}
    virtual std::unique_ptr<Shape> clone() const = 0;
    virtual void describe() const = 0;
};

class RoundShape : public Shape {
    int radius = 0;
public:
    RoundShape(std::string l, int w, int r) : Shape(std::move(l), w), radius(r) {}
    std::unique_ptr<Shape> clone() const override {
        return std::make_unique<RoundShape>(*this); // copy ctor copies all fields.
    }
    void describe() const override {
        std::cout << "RoundShape{" << label << ", w=" << weight << ", r=" << radius << "}\n";
    }
};

class BoxShape : public Shape {
    int side = 0;
public:
    BoxShape(std::string l, int w, int s) : Shape(std::move(l), w), side(s) {}
    std::unique_ptr<Shape> clone() const override {
        return std::make_unique<BoxShape>(*this);
    }
    void describe() const override {
        std::cout << "BoxShape{" << label << ", w=" << weight << ", side=" << side << "}\n";
    }
};

int main() {
    RoundShape original{"prototype-round", 5, 12};
    auto copy = original.clone();
    original.describe();
    copy->describe();

    BoxShape box{"prototype-box", 9, 4};
    box.clone()->describe();
    return 0;
}
