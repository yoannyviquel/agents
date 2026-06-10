# Visitor
> *Lets you separate algorithms from the objects on which they operate.*

**Category:** Behavioral

## Intent
Add new operations to a hierarchy of element classes without changing those classes, by placing each operation in a separate visitor object and using double dispatch to route calls.

## Problem
An app stores geographic info as a huge graph; each node type (City, Industry, SightSeeing, …) is its own class. You must export the graph to XML. Adding an `export` method to each node class is simple, but the architect refuses: the code is in production and risky to change, XML export doesn't belong in geodata classes, and more export formats will likely be requested later — forcing repeated changes to those fragile classes.

## Solution
Put the new behavior in a separate **visitor** class instead of integrating it into existing classes; the original object is passed to a visitor method as an argument. Since the behavior differs per node class, the visitor defines a *set* of methods (`doForCity(City)`, `doForIndustry(Industry)`, …). These methods have different signatures, so polymorphism alone can't pick the right one, and `instanceof` checks or overloading don't work (the exact class is unknown at compile time — overloading defaults to the base `Node`).

Visitor solves this with **Double Dispatch**: delegate the method choice to the objects being visited. Each element implements `accept(visitor)` and calls the matching visiting method (`v.doForCity(this)`), since the object knows its own class. This requires a trivial change to node classes (adding `accept`), but afterward you can add any new behavior by writing a new visitor — no further changes to the elements. Extract a common visitor interface and all nodes work with any visitor.

## Real-World Analogy
An insurance agent visiting buildings in a neighborhood offers different policies by organization type: a residential building → medical insurance, a bank → theft insurance, a coffee shop → fire/flood insurance.

## Structure
1. **Visitor** — interface declaring a set of visiting methods, one per concrete element class (same name if the language supports overloading, but distinct parameter types).
2. **Concrete Visitors** — implement several versions of the same behavior, tailored to each concrete element class.
3. **Element** — interface declaring an `accept` method taking the visitor interface as a parameter.
4. **Concrete Elements** — implement `accept` to redirect the call to the visitor method matching their class. Even if a base element implements it, every subclass must override `accept` and call the appropriate visitor method.
5. **Client** — usually a collection or complex object (e.g. a Composite tree); works with elements via an abstract interface, unaware of concrete element classes.

## Pseudocode (XML export of shapes)
`Shape` declares `move`, `draw`, and `accept(v: Visitor)`. `Dot`, `Circle`, `Rectangle`, `CompoundShape` each implement `accept` calling the matching method (`v.visitDot(this)`, etc.). The `Visitor` interface declares `visitDot`, `visitCircle`, `visitRectangle`, `visitCompoundShape`. `XMLExportVisitor` implements each (exporting IDs, coordinates, radius, children IDs). `Application.export()` creates an `XMLExportVisitor` and calls `shape.accept(exportVisitor)` for each shape — `accept` routes to the right method without the client knowing concrete classes. A visitor is especially useful over a Composite tree, where it can store intermediate state across visits.

## Applicability
- Use to **perform an operation on all elements of a complex object structure** (e.g. an object tree) across objects of different classes.
- Use to **clean up business logic** of auxiliary behaviors — keep primary classes focused on their main job by extracting other behaviors into visitors.
- Use when a behavior **makes sense only in some classes** of a hierarchy — implement only the relevant visiting methods, leaving the rest empty.

## How to Implement
1. Declare the visitor interface with a visiting method per concrete element class.
2. Declare the element interface (or add an abstract `accept` method to the base of an existing hierarchy) taking a visitor argument.
3. Implement `accept` in all concrete elements, redirecting to the visiting method matching the element's class.
4. Elements work with visitors only via the visitor interface; visitors must know all concrete element classes (as parameter types).
5. For each behavior that can't live in the element hierarchy, create a concrete visitor implementing all visiting methods. If a visitor needs private element members, make them public (breaking encapsulation) or nest the visitor in the element (if the language supports it).
6. The client creates visitors and passes them into elements via `accept`.

## Pros and Cons
- ✓ Open/Closed Principle: introduce new behavior over different classes without changing those classes.
- ✓ Single Responsibility Principle: move multiple versions of the same behavior into one class.
- ✓ A visitor can accumulate useful information while traversing a complex structure (e.g. an object tree).
- ✗ You must update all visitors each time a class is added to or removed from the element hierarchy.
- ✗ Visitors might lack access to private fields/methods of the elements they work with.

## Relations with Other Patterns
- Treat **Visitor** as a powerful version of **Command** — its objects execute operations over objects of different classes.
- Use **Visitor** to execute an operation over an entire **Composite** tree.
- Use **Visitor** with **Iterator** to traverse a complex data structure and run an operation over elements of different classes.

## Code Examples
- [C#](../code-examples/csharp/Visitor.cs)
- [Java](../code-examples/java/Visitor.java)
- [TypeScript](../code-examples/typescript/Visitor.ts)
- [C++](../code-examples/cpp/Visitor.cpp)
- [Swift](../code-examples/swift/Visitor.swift)
- [PHP](../code-examples/php/Visitor.php)
- [Python](../code-examples/python/visitor.py)
- [Go](../code-examples/go/visitor.go)
- [Ruby](../code-examples/ruby/visitor.rb)
- [Rust](../code-examples/rust/visitor.rs)
