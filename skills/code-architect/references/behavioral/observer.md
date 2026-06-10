# Observer
> *Lets you define a subscription mechanism to notify multiple objects about any events that happen to the object they're observing.*

**Category:** Behavioral
**Also known as:** Event-Subscriber, Listener

## Intent
Define a one-to-many dependency where a *publisher* notifies any number of *subscribers* of events, without the publisher being coupled to the subscribers' concrete classes.

## Problem
A `Customer` is interested in a product that will soon be available in a `Store`. The customer could visit the store daily (mostly wasted trips), or the store could email every customer on each new arrival (spam to the uninterested). Either the customer wastes time or the store wastes resources notifying the wrong people.

## Solution
The object with the interesting state is the **publisher** (a.k.a. subject); objects tracking its changes are **subscribers**. Add a subscription mechanism to the publisher: 1) an array field of references to subscriber objects and 2) public methods to add/remove subscribers. When an event happens, the publisher iterates its subscribers and calls a notification method on each. To avoid coupling the publisher to many subscriber classes, all subscribers implement the same interface declaring the notification method (with parameters for contextual data). If you have several publisher types, give them a common subscription interface too.

## Real-World Analogy
Magazine/newspaper subscriptions: instead of checking the store for each new issue, the publisher mails new issues to subscribers right after publication; subscribers can leave the list anytime.

## Structure
1. **Publisher** — issues events; contains subscription infrastructure to add/remove subscribers.
2. On a new event, the publisher iterates the subscription list and calls the subscriber-interface notification method on each.
3. **Subscriber** — interface declaring the notification interface, usually a single `update` method (possibly with parameters for event details).
4. **Concrete Subscribers** — act on notifications; all implement the same interface so the publisher isn't coupled to concrete classes.
5. The publisher often passes context data (or itself) as notification arguments so subscribers can fetch what they need.
6. **Client** — creates publishers and subscribers separately, then registers subscribers with publishers.

## Pseudocode (editor events)
`EventManager` holds a map of event types → listeners with `subscribe`, `unsubscribe`, and `notify(eventType, data)` (which calls `update(data)` on each listener). `Editor` owns an `EventManager` (composition — used because the concrete publisher may already be a subclass) and calls `events.notify("open"/"save", ...)` from its business methods. `EventListener` declares `update(filename)`; `LoggingListener` and `EmailAlertsListener` implement it. `Application.config()` wires listeners to specific event types at runtime — adding subscribers needs no change to the publisher as long as they share the interface.

## Applicability
- Use when changes to one object require changing others, and **the set of objects is unknown beforehand or changes dynamically** (e.g. custom GUI buttons letting clients hook custom code on press).
- Use when some objects must observe others **only for a limited time or in specific cases** — the dynamic subscription list lets subscribers join/leave as needed.

## How to Implement
1. Break business logic into a publisher (core functionality) and subscriber classes (the rest).
2. Declare the subscriber interface (at minimum an `update` method).
3. Declare the publisher interface with add/remove subscriber methods; publishers work with subscribers only via the subscriber interface.
4. Decide where the subscription list lives — usually an abstract class derived from the publisher interface (concrete publishers inherit it); for an existing hierarchy, use composition (a separate subscription object).
5. Create concrete publishers that notify all subscribers when something important happens.
6. Implement update methods in concrete subscribers (receive context via arguments, or fetch from the publisher passed via `update`, or link permanently via constructor — least flexible).
7. The client creates subscribers and registers them with publishers.

## Pros and Cons
- ✓ Open/Closed Principle: introduce new subscriber classes without changing the publisher (and vice versa if there's a publisher interface).
- ✓ Establish relations between objects at runtime.
- ✗ Subscribers are notified in random order.

## Relations with Other Patterns
- **CoR, Command, Mediator, Observer** offer different ways to connect senders/receivers: Observer lets receivers dynamically subscribe/unsubscribe.
- **Mediator vs. Observer**: Mediator eliminates mutual dependencies by routing through one object; Observer establishes dynamic one-way connections. A popular Mediator implementation uses Observer (mediator = publisher, components = subscribers), making them look alike — but Mediator can also be implemented without resembling Observer.

## Code Examples
- [C#](../code-examples/csharp/Observer.cs)
- [Java](../code-examples/java/Observer.java)
- [TypeScript](../code-examples/typescript/Observer.ts)
- [C++](../code-examples/cpp/Observer.cpp)
- [Swift](../code-examples/swift/Observer.swift)
- [PHP](../code-examples/php/Observer.php)
- [Python](../code-examples/python/observer.py)
- [Go](../code-examples/go/observer.go)
- [Ruby](../code-examples/ruby/observer.rb)
- [Rust](../code-examples/rust/observer.rs)
