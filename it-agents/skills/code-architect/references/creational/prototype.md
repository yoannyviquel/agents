# Prototype
> *Lets you copy existing objects without making your code dependent on their classes.*

**Category:** Creational
**Also known as:** Clone

## Intent
Delegate the cloning of an object to the object itself through a common `clone` interface, so client code can duplicate objects without knowing or depending on their concrete classes.

## Problem
To copy an object directly you must create a new object of the same class and copy every field. But some fields may be private and invisible from outside, and copying "from the outside" forces you to know the concrete class — coupling your code to it. Sometimes you only know the interface an object follows, not its concrete class (e.g. a parameter accepting any object implementing an interface).

## Solution
The Prototype pattern declares a common interface (usually a single `clone` method) for all objects that support cloning. An object that supports cloning is a *prototype*. Each class implements `clone` by creating an object of its own class and carrying over all field values — including private ones, since most languages let an object access private fields of other objects of the same class. When objects have many fields and configurations, cloning a pre-configured prototype is an alternative to subclassing.

## Real-World Analogy
Mitotic cell division: the original cell acts as a prototype and takes an active role in creating an identical copy of itself.

## Structure
**Basic implementation**
1. **Prototype** — interface declaring the cloning method(s), usually a single `clone`.
2. **Concrete Prototype** — implements `clone`; besides copying data, it may handle edge cases like cloning linked objects or untangling recursive dependencies.
3. **Client** — produces a copy of any object that follows the prototype interface.

**Prototype Registry**
- A **Prototype Registry** stores frequently-used pre-built prototypes (simplest form: a name → prototype map) and returns clones on request, enabling richer search criteria than a plain name.

## Pseudocode (shapes)
An abstract `Shape` has `X`, `Y`, `color`, a regular constructor, and a *prototype constructor* `Shape(source)` that copies fields from an existing shape, plus an abstract `clone(): Shape`. `Rectangle` and `Circle` extend it, call `super(source)` to copy parent fields, copy their own fields, and implement `clone()` by `return new Rectangle(this)` / `new Circle(this)`. Client code clones shapes polymorphically without knowing their concrete classes — performing the copy inside the constructor keeps the result consistent (no reference to a partially-built clone).

## Applicability
- Use when your code **shouldn't depend on the concrete classes** of objects you copy (e.g. objects passed from 3rd-party code via an interface).
- Use to **reduce the number of subclasses** that differ only in how they initialize objects — keep a set of pre-built prototypes configured in various ways and clone the appropriate one instead of instantiating a configuration subclass.

## How to Implement
1. Create the prototype interface with a `clone` method (or add the method to an existing class hierarchy).
2. Give each prototype class an alternative constructor accepting an object of that class and copying all its fields; call the parent constructor for inherited private fields. (If the language lacks method overloading, do the copying inside `clone` instead — though a regular constructor is safer.)
3. The cloning method is usually one line: `new` with the prototypical constructor. Every class must override `clone` using its own class name, or it may produce a parent-class object.
4. Optionally add a centralized prototype registry (a factory class or a static method on the base prototype) that finds a prototype by criteria, clones it, and returns the copy; replace direct subclass constructor calls with calls to it.

## Pros and Cons
- ✓ Clone objects without coupling to their concrete classes.
- ✓ Get rid of repeated initialization code by cloning pre-built prototypes.
- ✓ Produce complex objects more conveniently.
- ✓ An alternative to inheritance for configuration presets of complex objects.
- ✗ Cloning complex objects with circular references can be tricky.

## Relations with Other Patterns
- Designs often start with **Factory Method** and evolve toward Abstract Factory, **Prototype**, or Builder.
- **Abstract Factory** classes can use Prototype to compose their creation methods.
- Prototype can help save copies of **Command** objects into history.
- Designs heavy on **Composite** and **Decorator** benefit from Prototype — clone complex structures instead of rebuilding them.
- Prototype isn't inheritance-based (no inheritance drawbacks) but needs complicated initialization of the clone; **Factory Method** is inheritance-based but needs no initialization step.
- Prototype can be a simpler alternative to **Memento** for straightforward objects without links to external resources.
- Abstract Factories, **Builders**, and Prototypes can all be implemented as **Singletons**.

## Code Examples
- [C#](../code-examples/csharp/Prototype.cs)
- [Java](../code-examples/java/Prototype.java)
- [TypeScript](../code-examples/typescript/Prototype.ts)
- [C++](../code-examples/cpp/Prototype.cpp)
- [Swift](../code-examples/swift/Prototype.swift)
- [PHP](../code-examples/php/Prototype.php)
- [Python](../code-examples/python/prototype.py)
- [Go](../code-examples/go/prototype.go)
- [Ruby](../code-examples/ruby/prototype.rb)
- [Rust](../code-examples/rust/prototype.rs)
