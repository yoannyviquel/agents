# Command
> *Turns a request into a stand-alone object that contains all information about the request. This lets you pass requests as method arguments, delay or queue a request's execution, and support undoable operations.*

**Category:** Behavioral
**Also known as:** Action, Transaction

## Intent
Encapsulate a request as an object — the receiver, method, and arguments — so you can parameterize objects with operations, queue/log/schedule requests, and support undo.

## Problem
A text editor needs a toolbar of buttons. Putting click behavior into a `Button` subclass per use leads to a huge, fragile subclass hierarchy coupled to volatile business logic. Worse, operations like copy/paste are invoked from multiple places (toolbar button, context menu, `Ctrl+C`), forcing duplicated code or making menus depend on buttons.

## Solution
Follow separation of concerns by splitting the app into layers (GUI and business logic). Instead of GUI objects calling business-logic methods directly, extract all request details (target object, method name, arguments) into a separate **command** class with a single execution method. Commands become links between GUI and business-logic objects, so the GUI just triggers a command without knowing what processes it or how.

Make all commands implement the same interface (usually a single parameterless `execute()`), so one sender can work with various commands without coupling — and you can swap a sender's command at runtime. Since `execute()` takes no parameters, the command must be pre-configured with request data or able to obtain it. For the editor: a base `Button` gets a command-reference field and runs it on click; menus, shortcuts, and dialogs link to the same commands, removing duplication. Commands become a middle layer reducing coupling between GUI and business logic.

## Real-World Analogy
Ordering in a restaurant: the waiter writes your order on paper (the command) and sticks it on the kitchen wall; it waits in a queue until the chef reads it and cooks. The order holds all info needed, letting the chef start without clarifying with you directly.

## Structure
1. **Sender** (invoker) — initiates requests; holds a command reference and triggers it instead of calling the receiver directly. It doesn't create the command (usually gets it from the client via constructor).
2. **Command** — interface, usually a single execution method.
3. **Concrete Commands** — implement various requests; they don't do the work themselves but pass the call to a business-logic object (can be merged for simplicity). Request parameters are stored as fields (immutable via constructor).
4. **Receiver** — contains business logic; almost any object can be a receiver and does the actual work.
5. **Client** — creates and configures concrete commands, passing all request parameters (including a receiver) into the command's constructor; then associates commands with senders.

## Pseudocode (undoable text editor)
An abstract `Command` holds `app`, `editor`, and a `backup`; it offers `saveBackup()`, `undo()` (restore `backup`), and abstract `execute()` (returns whether it changed state). `CopyCommand` returns false (no state change, not saved); `CutCommand`/`PasteCommand` call `saveBackup()`, mutate the editor, return true; `UndoCommand` calls `app.undo()`. `CommandHistory` is a stack (`push`/`pop`). `Editor` is the receiver (`getSelection`, `deleteSelection`, `replaceSelection`). `Application` wires commands to buttons and shortcuts; `executeCommand(c)` runs `c.execute()` and pushes to history if it returns true; `undo()` pops the latest command and calls its `undo()` — without knowing the command's class.

## Applicability
- Use to **parameterize objects with operations** — turn a method call into a stand-alone object you can pass around, store, and swap at runtime (e.g. configurable context-menu items).
- Use to **queue, schedule, or execute operations remotely** — commands can be serialized, so you can delay, queue, log, or send them over the network.
- Use to **implement reversible operations (undo/redo)** — keep a history stack of executed commands with state backups. Drawbacks: saving full state is hard (mitigate with **Memento**) and may consume much RAM (alternative: have the command perform the inverse operation, though that can be hard/impossible).

## How to Implement
1. Declare the command interface with a single execution method.
2. Extract requests into concrete command classes with fields for arguments and a receiver reference, all set via constructor.
3. Identify sender classes; add command-storage fields; senders talk to commands only via the interface and usually receive commands from the client.
4. Change senders to execute the command instead of calling the receiver directly.
5. Client initialization order: create receivers → create commands (associate with receivers) → create senders (associate with commands).

## Pros and Cons
- ✓ Single Responsibility Principle: decouple classes invoking operations from classes performing them.
- ✓ Open/Closed Principle: introduce new commands without breaking client code.
- ✓ Implement undo/redo and deferred execution.
- ✓ Assemble simple commands into a complex one (macro commands).
- ✗ Code can become more complicated (a whole new layer between senders and receivers).

## Relations with Other Patterns
- **CoR, Command, Mediator, Observer** offer different ways to connect senders/receivers (see Chain of Responsibility).
- CoR handlers can be implemented as Commands; or the request itself can be a Command.
- Use **Command** with **Memento** for undo: commands perform operations, mementos save state before execution.
- **Command** and **Strategy** look similar (both parameterize with an action), but Command converts an operation into an object (deferred/queued/logged), while Strategy describes interchangeable ways of doing the same thing in one context.
- **Prototype** can help save copies of commands into history.
- **Visitor** can be seen as a powerful version of Command operating over objects of different classes.

## Code Examples
- [C#](../code-examples/csharp/Command.cs)
- [Java](../code-examples/java/Command.java)
- [TypeScript](../code-examples/typescript/Command.ts)
- [C++](../code-examples/cpp/Command.cpp)
- [Swift](../code-examples/swift/Command.swift)
- [PHP](../code-examples/php/Command.php)
- [Python](../code-examples/python/command.py)
- [Go](../code-examples/go/command.go)
- [Ruby](../code-examples/ruby/command.rb)
- [Rust](../code-examples/rust/command.rs)
