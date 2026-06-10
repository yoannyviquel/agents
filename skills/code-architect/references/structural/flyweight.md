# Flyweight
> *Lets you fit more objects into the available amount of RAM by sharing common parts of state between multiple objects instead of keeping all of the data in each object.*

**Category:** Structural
**Also known as:** Cache

## Intent
Reduce memory use when a program holds a huge number of similar objects by sharing the constant (intrinsic) portion of their state across objects and keeping only the varying (extrinsic) part per use.

## Problem
A video game with a realistic particle system (bullets, missiles, shrapnel) crashes on a friend's lower-RAM machine. Each particle is a separate object storing lots of data; at peak carnage, new particles no longer fit in RAM.

## Solution
The `color` and `sprite` fields consume the most memory and are nearly identical across particles (all bullets share color/sprite), while coordinates, vector, and speed are unique per particle and change over time.
- **Intrinsic state** — the constant data living inside the object; other objects can only read it.
- **Extrinsic state** — the rest, often changed from the outside.

Flyweight stops storing extrinsic state inside the object and instead passes it to the methods that need it. Only intrinsic state stays, so the object can be reused across contexts. For the game, three flyweights (bullet, missile, shrapnel) suffice. An object storing only intrinsic state is a *flyweight*.

**Extrinsic state storage** — the extrinsic state moves to a container or, more elegantly, to a separate *context* class storing it plus a reference to the flyweight; a thousand small contexts reuse one heavy flyweight.

**Immutability** — since a flyweight is shared across contexts, its state must not change: initialize once via constructor, expose no setters/public fields.

**Flyweight factory** — a factory method manages a pool of flyweights: given intrinsic state, it returns a matching existing flyweight or creates and pools a new one. It can live in a container, a separate factory class, or as a static method on the flyweight class.

## Structure
1. Flyweight is **merely an optimization** — apply it only after confirming a real RAM problem from many similar objects that can't be solved otherwise.
2. **Flyweight** — holds the shareable (intrinsic) state, usable across many contexts.
3. **Context** — holds the extrinsic state, unique per original object; paired with a flyweight it represents the full original object.
4. Behavior usually stays in the flyweight class (callers pass extrinsic state as method parameters), or can move to the context which treats the flyweight as a data object.
5. **Client** — computes/stores the extrinsic state; treats a flyweight as a template configured at call time via parameters.
6. **Flyweight Factory** — manages the pool; clients request flyweights through it by intrinsic state rather than creating them directly.

## Pseudocode (forest of trees)
`TreeType` (flyweight) holds `name`, `color`, `texture` and a `draw(canvas, x, y)`. `TreeFactory.getTreeType(name, color, texture)` returns an existing matching type or creates one. `Tree` (context) holds `x`, `y`, and a `type: TreeType` reference, delegating `draw(canvas)` to `type.draw(...)`. `Forest.plantTree(...)` obtains a flyweight from the factory and creates a small `Tree`; rendering millions of trees keeps the heavy texture/color data in just a few flyweights.

## Applicability
- Use **only** when your program must support a huge number of objects that barely fit in RAM. Most useful when: the app spawns a huge number of similar objects, this drains RAM on the target device, and the objects contain duplicate state that can be extracted and shared.

## How to Implement
1. Split the class's fields into intrinsic (unchanging, duplicated) and extrinsic (contextual, unique) state.
2. Keep the intrinsic fields in the class but make them immutable (set only in the constructor).
3. For each method using extrinsic fields, replace the field with a new method parameter.
4. Optionally create a factory managing the flyweight pool; clients request flyweights through it by intrinsic state.
5. The client stores/computes the extrinsic state (optionally in a separate context class holding the flyweight reference).

## Pros and Cons
- ✓ Save lots of RAM when the program has tons of similar objects.
- ✗ May trade RAM for CPU cycles when context data must be recalculated on each flyweight method call.
- ✗ Code becomes much more complicated; newcomers wonder why entity state was split this way.

## Relations with Other Patterns
- Implement shared leaf nodes of a **Composite** tree as Flyweights to save RAM.
- **Flyweight** makes lots of little objects; **Facade** makes one object representing a whole subsystem.
- **Flyweight** resembles **Singleton** if all shared state collapses to one object, but a Flyweight class can have many instances with different intrinsic states, and a Singleton can be mutable while Flyweights are immutable.

## Code Examples
- [C#](../code-examples/csharp/Flyweight.cs)
- [Java](../code-examples/java/Flyweight.java)
- [TypeScript](../code-examples/typescript/Flyweight.ts)
- [C++](../code-examples/cpp/Flyweight.cpp)
- [Swift](../code-examples/swift/Flyweight.swift)
- [PHP](../code-examples/php/Flyweight.php)
- [Python](../code-examples/python/flyweight.py)
- [Go](../code-examples/go/flyweight.go)
- [Ruby](../code-examples/ruby/flyweight.rb)
- [Rust](../code-examples/rust/flyweight.rs)
