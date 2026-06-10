# Composite
> *Lets you compose objects into tree structures and then work with these structures as if they were individual objects.*

**Category:** Structural
**Also known as:** Object Tree

## Intent
Treat individual objects (leaves) and compositions of objects (containers) uniformly through one common interface, so client code can run a behavior recursively over a whole object tree without knowing concrete classes.

## Problem
Only makes sense when the core model can be a tree. Example: `Products` and `Boxes`; a `Box` can hold products and smaller boxes, which hold more products/boxes, etc. Computing the total price of an order via the direct approach (unwrap every box, loop over products) requires knowing all classes and nesting levels beforehand — awkward or impossible.

## Solution
Work with products and boxes through a common interface declaring, say, `getPrice()`. For a product it returns the price; for a box it iterates its items, asks each for its price, and sums them (a nested box recurses), optionally adding packaging cost. You don't need to know whether an object is a simple product or a box — the objects pass the request down the tree themselves.

## Real-World Analogy
A military hierarchy: army → divisions → brigades → platoons → squads → soldiers. Orders are given at the top and passed down each level until every soldier knows what to do.

## Structure
1. **Component** — interface describing operations common to both simple and complex elements.
2. **Leaf** — a basic element with no sub-elements; leaves usually do the real work (no one to delegate to).
3. **Container** (a.k.a. composite) — an element with sub-elements (leaves or other containers); it knows its children only via the component interface, delegates work to them, processes intermediate results, and returns the final one.
4. **Client** — works with all elements through the component interface, treating simple and complex elements the same way.

## Pseudocode (graphics editor)
`Graphic` declares `move(x, y)` and `draw()`. `Dot` (leaf) implements them; `Circle extends Dot`. `CompoundGraphic` (composite) holds `children: array of Graphic`, with `add`/`remove`; its `move` and `draw` iterate children and recurse, so the whole tree is traversed. `ImageEditor` builds the tree and can `groupSelected(...)` components into a new `CompoundGraphic` — the client works only through `Graphic`, never coupled to concrete classes.

## Applicability
- Use when you must implement a **tree-like object structure** — Composite gives two element types (leaves, containers) sharing one interface, letting you build nested recursive structures.
- Use when you want client code to **treat simple and complex elements uniformly** through the common interface.

## How to Implement
1. Ensure the core model can be a tree; break it into simple elements and containers (containers must hold both leaves and other containers).
2. Declare the component interface with methods meaningful to both simple and complex components.
3. Create a leaf class (or several) for simple elements.
4. Create a container class with an array field (typed as the component interface) for sub-elements; delegate most work to them.
5. Define child add/remove methods. Declaring them on the component interface violates the **Interface Segregation Principle** (empty in leaves) but lets the client treat all elements equally — a deliberate trade-off.

## Pros and Cons
- ✓ Work with complex tree structures conveniently via polymorphism and recursion.
- ✓ Open/Closed Principle: introduce new element types without breaking code that works with the tree.
- ✗ Hard to provide a common interface for classes whose functionality differs too much; you may overgeneralize the component interface, hurting comprehension.

## Relations with Other Patterns
- Use **Builder** to create complex Composite trees (recursive construction steps).
- **Chain of Responsibility** often works with Composite: a leaf's request can travel up through parent components to the root.
- Use **Iterators** to traverse Composite trees and **Visitor** to run an operation over a whole tree.
- Implement shared leaf nodes as **Flyweights** to save RAM.
- **Composite** and **Decorator** have similar structure (both use recursive composition). A Decorator is like a Composite with a single child, but a Decorator *adds responsibilities* while a Composite just *sums up* its children's results; they can cooperate.
- Heavy use of Composite + Decorator benefits from **Prototype** (clone complex structures instead of rebuilding).

## Code Examples
- [C#](../code-examples/csharp/Composite.cs)
- [Java](../code-examples/java/Composite.java)
- [TypeScript](../code-examples/typescript/Composite.ts)
- [C++](../code-examples/cpp/Composite.cpp)
- [Swift](../code-examples/swift/Composite.swift)
- [PHP](../code-examples/php/Composite.php)
- [Python](../code-examples/python/composite.py)
- [Go](../code-examples/go/composite.go)
- [Ruby](../code-examples/ruby/composite.rb)
- [Rust](../code-examples/rust/composite.rs)
