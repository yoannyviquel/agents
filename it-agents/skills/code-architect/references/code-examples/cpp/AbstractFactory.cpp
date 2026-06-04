// Abstract Factory — create families of related objects without specifying concrete classes.
#include <iostream>
#include <memory>
#include <string>

// Abstract products.
class Surface {
public:
    virtual ~Surface() = default;
    virtual std::string paint() const = 0;
};

class Control {
public:
    virtual ~Control() = default;
    virtual std::string render() const = 0;
};

// Concrete products for theme A.
class DarkSurface : public Surface {
public:
    std::string paint() const override { return "dark surface"; }
};
class DarkControl : public Control {
public:
    std::string render() const override { return "dark control"; }
};

// Concrete products for theme B.
class LightSurface : public Surface {
public:
    std::string paint() const override { return "light surface"; }
};
class LightControl : public Control {
public:
    std::string render() const override { return "light control"; }
};

// Abstract factory.
class ThemeFactory {
public:
    virtual ~ThemeFactory() = default;
    virtual std::unique_ptr<Surface> createSurface() const = 0;
    virtual std::unique_ptr<Control> createControl() const = 0;
};

class DarkFactory : public ThemeFactory {
public:
    std::unique_ptr<Surface> createSurface() const override { return std::make_unique<DarkSurface>(); }
    std::unique_ptr<Control> createControl() const override { return std::make_unique<DarkControl>(); }
};

class LightFactory : public ThemeFactory {
public:
    std::unique_ptr<Surface> createSurface() const override { return std::make_unique<LightSurface>(); }
    std::unique_ptr<Control> createControl() const override { return std::make_unique<LightControl>(); }
};

void buildScreen(const ThemeFactory& factory) {
    auto surface = factory.createSurface();
    auto control = factory.createControl();
    std::cout << "Screen: " << surface->paint() << " + " << control->render() << ".\n";
}

int main() {
    buildScreen(DarkFactory{});
    buildScreen(LightFactory{});
    return 0;
}
