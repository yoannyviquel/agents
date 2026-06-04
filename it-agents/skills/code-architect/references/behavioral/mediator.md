# Mediator
> *Lets you reduce chaotic dependencies between objects. The pattern restricts direct communications between the objects and forces them to collaborate only via a mediator object.*

**Category:** Behavioral
**Also known as:** Intermediary, Controller

## Intent
Encapsulate the web of interactions between a set of objects inside a single mediator object, so components depend only on the mediator instead of on each other.

## Problem
A customer-profile dialog has many form controls (text fields, checkboxes, buttons) that interact: checking "I have a dog" reveals a dog-name field; the submit button validates all fields before saving. Putting this logic directly inside the elements couples them — you can't reuse the checkbox in another form because it's tied to the dog field. It's all-or-nothing.

## Solution
Stop all direct communication between components you want to decouple; have them collaborate indirectly via a **mediator** object that redirects calls. Components then depend only on the mediator class, not on dozens of colleagues. For the form, the dialog itself acts as the mediator (it already knows its sub-elements). The submit button's only job becomes notifying the dialog of a click; the dialog performs (or delegates) the validation. Extract a common dialog interface declaring a notification method, and the button works with any dialog implementing it. Fewer dependencies make a class easier to modify, extend, and reuse.

## Real-World Analogy
Air traffic control: pilots near an airport don't talk to each other directly — they communicate through the control tower, which enforces constraints in the terminal area. Without it, every pilot would have to track every nearby plane.

## Structure
1. **Components** — classes with business logic; each holds a reference to the mediator (typed as the mediator interface, unaware of its concrete class), so it can be reused with a different mediator.
2. **Mediator** — interface declaring communication methods, usually a single `notify` method; components pass context as arguments without coupling to each other's classes.
3. **Concrete Mediators** — encapsulate relations between components; often keep references to all managed components and may manage their life cycle.
4. **Components must not be aware of other components.** When something happens, a component only notifies the mediator, which identifies the sender and decides which component to trigger. To a component it's a black box — sender doesn't know who handles it, receiver doesn't know who sent it.

## Pseudocode (authentication dialog)
`Mediator` declares `notify(sender, event)`. `AuthenticationDialog` implements it, holding all components (login/register checkbox, username/password textboxes, OK/Cancel buttons) and untangling their relations in `notify`: on checkbox "check" it switches between login/registration layouts; on OK "click" it validates and logs in or registers. `Component` holds a `dialog: Mediator` and calls `dialog.notify(this, "click")` etc.; `Button`, `Textbox`, `Checkbox` extend it and communicate only by notifying the mediator — never each other.

## Applicability
- Use when it's **hard to change classes because they're tightly coupled** to many others — extract all relationships into a separate class, isolating changes.
- Use when you **can't reuse a component** because it depends on too many others — after Mediator, provide a new mediator class to reuse the component elsewhere.
- Use when you create **tons of component subclasses** just to reuse basic behavior in various contexts — define new collaborations via new mediator classes instead of changing components.

## How to Implement
1. Identify a group of tightly coupled classes that would benefit from independence.
2. Declare the mediator interface and the communication protocol (usually a single notification method) — crucial for reusing components in different contexts.
3. Implement the concrete mediator, storing references to all components so it can call any of them.
4. Optionally make the mediator responsible for creating/destroying components (then it resembles a factory or facade).
5. Components store a reference to the mediator (set via constructor).
6. Change components to call the mediator's notification method instead of other components' methods; move cross-component code into the mediator, run on notification.

## Pros and Cons
- ✓ Single Responsibility Principle: communications extracted to one place, easier to comprehend and maintain.
- ✓ Open/Closed Principle: introduce new mediators without changing components.
- ✓ Reduce coupling between components.
- ✓ Reuse individual components more easily.
- ✗ Over time a mediator can evolve into a *God Object*.

## Relations with Other Patterns
- **CoR, Command, Mediator, Observer** offer different ways to connect senders/receivers: Mediator eliminates direct connections, forcing indirect communication via a mediator.
- **Facade** and Mediator both organize collaboration among tightly coupled classes, but Facade only simplifies the interface (subsystem unaware, members talk directly), while Mediator centralizes communication (members know only the mediator).
- **Mediator vs. Observer**: Mediator removes mutual dependencies by routing through one object; Observer establishes dynamic one-way connections. A popular Mediator implementation uses Observer (the mediator is the publisher, components subscribe), making the two look alike — but Mediator can also be implemented by permanently linking components to one mediator, which doesn't resemble Observer.

## Code Examples
- [C#](../code-examples/csharp/Mediator.cs)
- [Java](../code-examples/java/Mediator.java)
- [TypeScript](../code-examples/typescript/Mediator.ts)
- [C++](../code-examples/cpp/Mediator.cpp)
- [Swift](../code-examples/swift/Mediator.swift)
- [PHP](../code-examples/php/Mediator.php)
- [Python](../code-examples/python/mediator.py)
- [Go](../code-examples/go/mediator.go)
- [Ruby](../code-examples/ruby/mediator.rb)
- [Rust](../code-examples/rust/mediator.rs)
