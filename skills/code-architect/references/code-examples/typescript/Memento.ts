// Memento — capture and restore an object's state without breaking encapsulation.

// Opaque snapshot; only the originator understands its contents.
class Memento {
  constructor(private readonly state: string) {}
  // Restricted accessor used solely by the originator.
  getState(): string {
    return this.state;
  }
}

class TextEditor {
  private content = "";

  type(text: string): void {
    this.content += text;
  }

  save(): Memento {
    return new Memento(this.content);
  }

  restore(memento: Memento): void {
    this.content = memento.getState();
  }

  get text(): string {
    return this.content;
  }
}

// Caretaker keeps mementos but never inspects them.
class History {
  private stack: Memento[] = [];
  backup(memento: Memento): void {
    this.stack.push(memento);
  }
  pop(): Memento | undefined {
    return this.stack.pop();
  }
}

function demo(): void {
  const editor = new TextEditor();
  const history = new History();

  editor.type("Hello");
  history.backup(editor.save());
  editor.type(", world");
  console.log(`before undo: "${editor.text}"`);

  const snapshot = history.pop();
  if (snapshot) editor.restore(snapshot);
  console.log(`after undo:  "${editor.text}"`);
}

demo();
