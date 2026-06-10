// Abstract Factory — create families of related objects without specifying concrete classes.

interface Button { String render(); }
interface Checkbox { String render(); }

class LightButton implements Button {
    public String render() { return "[ Light Button ]"; }
}
class LightCheckbox implements Checkbox {
    public String render() { return "( Light Checkbox )"; }
}
class DarkButton implements Button {
    public String render() { return "[[ Dark Button ]]"; }
}
class DarkCheckbox implements Checkbox {
    public String render() { return "(( Dark Checkbox ))"; }
}

interface WidgetFactory {
    Button createButton();
    Checkbox createCheckbox();
}

class LightWidgetFactory implements WidgetFactory {
    public Button createButton() { return new LightButton(); }
    public Checkbox createCheckbox() { return new LightCheckbox(); }
}

class DarkWidgetFactory implements WidgetFactory {
    public Button createButton() { return new DarkButton(); }
    public Checkbox createCheckbox() { return new DarkCheckbox(); }
}

class Screen {
    private final Button button;
    private final Checkbox checkbox;
    Screen(WidgetFactory factory) {
        this.button = factory.createButton();
        this.checkbox = factory.createCheckbox();
    }
    String draw() { return button.render() + " " + checkbox.render(); }
}

public class AbstractFactory {
    public static void main(String[] args) {
        System.out.println(new Screen(new LightWidgetFactory()).draw());
        System.out.println(new Screen(new DarkWidgetFactory()).draw());
    }
}
