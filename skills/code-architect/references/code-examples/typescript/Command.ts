// Command — encapsulate a request as an object, support undo.

interface Command {
  execute(): void;
  undo(): void;
}

// Receiver holding the state commands act upon.
class Counter {
  value = 0;
}

class IncrementCommand implements Command {
  constructor(private readonly counter: Counter, private readonly by: number) {}
  execute(): void {
    this.counter.value += this.by;
  }
  undo(): void {
    this.counter.value -= this.by;
  }
}

// Invoker records history to support undo.
class CommandInvoker {
  private history: Command[] = [];

  run(command: Command): void {
    command.execute();
    this.history.push(command);
  }

  undoLast(): void {
    const command = this.history.pop();
    command?.undo();
  }
}

function demo(): void {
  const counter = new Counter();
  const invoker = new CommandInvoker();

  invoker.run(new IncrementCommand(counter, 5));
  invoker.run(new IncrementCommand(counter, 3));
  console.log(`value = ${counter.value}`); // 8
  invoker.undoLast();
  console.log(`after undo = ${counter.value}`); // 5
}

demo();
