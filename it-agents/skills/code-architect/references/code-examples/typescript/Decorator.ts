// Decorator — attach responsibilities by wrapping objects at runtime.

interface TextSource {
  read(): string;
}

class PlainText implements TextSource {
  constructor(private readonly content: string) {}
  read(): string {
    return this.content;
  }
}

// Base decorator forwards to the wrapped component.
abstract class TextDecorator implements TextSource {
  constructor(protected readonly wrapped: TextSource) {}
  abstract read(): string;
}

class UpperCaseDecorator extends TextDecorator {
  read(): string {
    return this.wrapped.read().toUpperCase();
  }
}

class BracketDecorator extends TextDecorator {
  read(): string {
    return `[${this.wrapped.read()}]`;
  }
}

function demo(): void {
  let source: TextSource = new PlainText("hello");
  source = new UpperCaseDecorator(source);
  source = new BracketDecorator(source);
  console.log(source.read()); // [HELLO]
}

demo();
