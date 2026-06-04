# Design Patterns — Master Index

This knowledge base is derived from *Dive Into Design Patterns* (Alexander Shvets, refactoring.guru) and its companion code in 10 languages. It is the **single source of truth** for the `code-architect` agent. Cover the 22 classic GoF patterns described in the book (the book intentionally omits *Interpreter*; companion code includes it for Java/PHP only).

## How to use this index
1. Clarify the **functional need** and the forces at play (what varies, what must stay stable, coupling, runtime vs. compile-time, performance).
2. Use the **principles** below to frame the design before reaching for a pattern — most problems are solved by good design principles, not by a named pattern.
3. Use the **selector** to shortlist candidate patterns, then read each candidate's reference file in full before recommending it.
4. Follow the per-pattern **Applicability**, **Pros and Cons**, and **Relations with Other Patterns** sections to justify or reject a choice.

> A pattern is not a recipe to apply blindly. Applying a pattern always adds classes/indirection — only do it when the problem genuinely matches the pattern's intent.

## Foundations (read first)
- [OOP basics](./principles/01-oop-basics.md)
- [Pillars of OOP](./principles/02-oop-pillars.md) — abstraction, encapsulation, inheritance, polymorphism
- [Relations between objects](./principles/03-relations-between-objects.md) — dependency, association, aggregation, composition, implementation, inheritance
- [What is a design pattern?](./principles/04-what-is-a-design-pattern.md)
- [Features of good design](./principles/05-features-of-good-design.md) — code reuse, extensibility
- [Design principles](./principles/06-design-principles.md) — **Encapsulate What Varies**, **Program to an Interface**, **Favor Composition Over Inheritance**
- [SOLID](./principles/07-solid.md) — SRP, OCP, LSP, ISP, DIP

## Catalog

### Creational — *object creation mechanisms*
| Pattern | One-liner |
|---------|-----------|
| [Factory Method](./creational/factory-method.md) | Subclasses decide which product class to instantiate, via a factory method. |
| [Abstract Factory](./creational/abstract-factory.md) | Create families of related objects without naming concrete classes. |
| [Builder](./creational/builder.md) | Construct complex objects step by step; same process, different representations. |
| [Prototype](./creational/prototype.md) | Copy existing objects without coupling to their classes. |
| [Singleton](./creational/singleton.md) | One instance, global access point. |

### Structural — *assembling objects and classes into larger structures*
| Pattern | One-liner |
|---------|-----------|
| [Adapter](./structural/adapter.md) | Make incompatible interfaces collaborate. |
| [Bridge](./structural/bridge.md) | Split abstraction and implementation into independent hierarchies. |
| [Composite](./structural/composite.md) | Treat individual objects and trees of objects uniformly. |
| [Decorator](./structural/decorator.md) | Add responsibilities by wrapping objects at runtime. |
| [Facade](./structural/facade.md) | A simple interface to a complex subsystem. |
| [Flyweight](./structural/flyweight.md) | Share intrinsic state across many objects to save RAM. |
| [Proxy](./structural/proxy.md) | A placeholder controlling access to another object (lazy/caching/access/remote). |

### Behavioral — *algorithms and assignment of responsibilities*
| Pattern | One-liner |
|---------|-----------|
| [Chain of Responsibility](./behavioral/chain-of-responsibility.md) | Pass a request along a chain of handlers. |
| [Command](./behavioral/command.md) | Turn a request into an object (queue, log, undo). |
| [Iterator](./behavioral/iterator.md) | Traverse a collection without exposing its structure. |
| [Mediator](./behavioral/mediator.md) | Centralize chaotic inter-object communication. |
| [Memento](./behavioral/memento.md) | Save/restore an object's state without breaking encapsulation. |
| [Observer](./behavioral/observer.md) | Subscription mechanism to notify objects of events. |
| [State](./behavioral/state.md) | Change behavior when internal state changes (state objects). |
| [Strategy](./behavioral/strategy.md) | A family of interchangeable algorithms. |
| [Template Method](./behavioral/template-method.md) | Algorithm skeleton in a superclass, steps overridden by subclasses. |
| [Visitor](./behavioral/visitor.md) | Separate algorithms from the objects they operate on. |

## Quick selector (problem → candidate patterns)
Candidates are starting points — always confirm against the pattern's own Applicability section.

- **"I must create objects but don't want to hard-code their concrete classes."** → Factory Method; if whole *families* must stay consistent → Abstract Factory.
- **"A constructor has too many parameters / many representations of one product."** → Builder.
- **"I need to copy objects whose concrete classes I don't know."** → Prototype.
- **"I need exactly one shared instance."** → Singleton (consider dependency injection first; note testability/coupling downsides).
- **"Two interfaces are incompatible / integrating a legacy or 3rd-party class."** → Adapter.
- **"A class explodes across two independent dimensions."** → Bridge.
- **"I need tree structures treated uniformly (whole/part)."** → Composite.
- **"I need to add responsibilities to objects at runtime / avoid a subclass explosion of feature combinations."** → Decorator.
- **"I need a simple entry point over a complex subsystem."** → Facade.
- **"Too many similar objects exhaust RAM."** → Flyweight (optimization — confirm the RAM problem first).
- **"I need to control access to an object (lazy init, caching, access control, remoting, logging)."** → Proxy.
- **"A request should be handled by one of several handlers, order/handlers vary."** → Chain of Responsibility.
- **"I need undo/redo, queuing, or to decouple invokers from operations."** → Command (+ Memento for state snapshots).
- **"I must traverse a collection many ways without exposing its structure."** → Iterator.
- **"Objects are tightly, chaotically coupled to each other."** → Mediator.
- **"I need to snapshot/restore an object's state (undo, transactions)."** → Memento.
- **"Many objects must react to another object's events; the set is dynamic."** → Observer.
- **"Behavior depends on a state machine with growing conditionals."** → State.
- **"I have interchangeable algorithm variants / a big conditional selecting an algorithm."** → Strategy.
- **"Several classes share an algorithm structure but differ in some steps."** → Template Method.
- **"I must add operations to a class hierarchy without modifying those classes."** → Visitor.

## Code examples
Every pattern reference links to its concrete implementations across all 10 languages. See [code-examples/INDEX.md](./code-examples/INDEX.md) for the full pattern → language → folder map. When recommending a pattern, point to the example in the language the target codebase already uses.
