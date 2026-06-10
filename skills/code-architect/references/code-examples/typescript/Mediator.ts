// Mediator — centralize communication between components.

interface Mediator {
  notify(sender: Component, event: string): void;
}

abstract class Component {
  // Mediator is attached after construction to avoid a circular dependency.
  protected mediator: Mediator | null = null;
  setMediator(mediator: Mediator): void {
    this.mediator = mediator;
  }
}

class TextInput extends Component {
  private text = "";
  type(value: string): void {
    this.text = value;
    this.mediator?.notify(this, "input");
  }
  get value(): string {
    return this.text;
  }
}

class SubmitButton extends Component {
  enabled = false;
  click(): void {
    if (this.enabled) {
      this.mediator?.notify(this, "submit");
    }
  }
}

// Concrete mediator wires components without them knowing each other.
class FormMediator implements Mediator {
  constructor(private input: TextInput, private button: SubmitButton) {
    input.setMediator(this);
    button.setMediator(this);
  }

  notify(sender: Component, event: string): void {
    if (sender === this.input && event === "input") {
      this.button.enabled = this.input.value.length > 0;
      console.log(`button enabled: ${this.button.enabled}`);
    }
    if (sender === this.button && event === "submit") {
      console.log(`submitting "${this.input.value}"`);
    }
  }
}

function demo(): void {
  const input = new TextInput();
  const button = new SubmitButton();
  new FormMediator(input, button);

  input.type("hello");
  button.click();
}

demo();
