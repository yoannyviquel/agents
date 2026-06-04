// Command — encapsulate a request as an object, support undo.

import java.util.ArrayDeque;
import java.util.Deque;

class Counter {
    private int value = 0;
    void add(int n) { value += n; }
    void subtract(int n) { value -= n; }
    int value() { return value; }
}

interface Action {
    void execute();
    void undo();
}

class AddCommand implements Action {
    private final Counter counter;
    private final int amount;
    AddCommand(Counter counter, int amount) { this.counter = counter; this.amount = amount; }
    public void execute() { counter.add(amount); }
    public void undo() { counter.subtract(amount); }
}

class Invoker {
    private final Deque<Action> history = new ArrayDeque<>();
    void run(Action c) { c.execute(); history.push(c); }
    void undoLast() { if (!history.isEmpty()) history.pop().undo(); }
}

public class Command {
    public static void main(String[] args) {
        Counter counter = new Counter();
        Invoker invoker = new Invoker();

        invoker.run(new AddCommand(counter, 5));
        invoker.run(new AddCommand(counter, 3));
        System.out.println("after adds: " + counter.value());

        invoker.undoLast();
        System.out.println("after undo: " + counter.value());
    }
}
