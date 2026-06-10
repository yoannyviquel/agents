// Abstract Factory — create families of related objects without specifying concrete classes.

protocol Button {
    func render() -> String
}

protocol Slider {
    func render() -> String
}

protocol WidgetFactory {
    func makeButton() -> Button
    func makeSlider() -> Slider
}

struct LightButton: Button {
    func render() -> String { "[ Light Button ]" }
}

struct LightSlider: Slider {
    func render() -> String { "—o— Light Slider" }
}

struct DarkButton: Button {
    func render() -> String { "█ Dark Button █" }
}

struct DarkSlider: Slider {
    func render() -> String { "■o■ Dark Slider" }
}

struct LightThemeFactory: WidgetFactory {
    func makeButton() -> Button { LightButton() }
    func makeSlider() -> Slider { LightSlider() }
}

struct DarkThemeFactory: WidgetFactory {
    func makeButton() -> Button { DarkButton() }
    func makeSlider() -> Slider { DarkSlider() }
}

func buildScreen(using factory: WidgetFactory) {
    print(factory.makeButton().render())
    print(factory.makeSlider().render())
}

func runDemo() {
    print("Light theme:")
    buildScreen(using: LightThemeFactory())
    print("Dark theme:")
    buildScreen(using: DarkThemeFactory())
}

runDemo()
