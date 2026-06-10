// Abstract Factory — create families of related objects without specifying concrete classes.

interface Button {
  render(): string;
}

interface Switch {
  toggle(): string;
}

interface WidgetFactory {
  makeButton(): Button;
  makeSwitch(): Switch;
}

class LightButton implements Button {
  render(): string {
    return "[ Light Button ]";
  }
}

class LightSwitch implements Switch {
  toggle(): string {
    return "light switch flipped";
  }
}

class DarkButton implements Button {
  render(): string {
    return "[ Dark Button ]";
  }
}

class DarkSwitch implements Switch {
  toggle(): string {
    return "dark switch flipped";
  }
}

class LightThemeFactory implements WidgetFactory {
  makeButton(): Button {
    return new LightButton();
  }
  makeSwitch(): Switch {
    return new LightSwitch();
  }
}

class DarkThemeFactory implements WidgetFactory {
  makeButton(): Button {
    return new DarkButton();
  }
  makeSwitch(): Switch {
    return new DarkSwitch();
  }
}

function buildUi(factory: WidgetFactory): void {
  const button = factory.makeButton();
  const toggle = factory.makeSwitch();
  console.log(`${button.render()} -> ${toggle.toggle()}`);
}

function demo(): void {
  buildUi(new LightThemeFactory());
  buildUi(new DarkThemeFactory());
}

demo();
