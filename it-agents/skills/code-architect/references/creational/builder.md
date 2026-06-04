# Builder
> *Lets you construct complex objects step by step, producing different types and representations of an object using the same construction code.*

**Category:** Creational

## Intent
Extract the step-by-step construction of a complex object into separate *builder* objects, so the same construction process can yield different representations and you avoid monstrous constructors.

## Problem
A complex object needs laborious, step-by-step initialization of many fields and nested objects — usually buried in a giant constructor with lots of parameters, or scattered across client code. Example: a `House` needs walls, floor, door, windows, roof — but maybe also a garage, pool, garden, heating, etc.
- Subclassing for every combination of parameters explodes the class hierarchy.
- A single giant constructor eliminates subclasses but leaves most parameters unused on most calls, making calls ugly.

## Solution
Move object construction out of the class into separate **builder** objects. The builder organizes construction into steps (`buildWalls`, `buildDoor`, …); you only call the steps needed for a particular configuration. Different **concrete builders** implement the same steps differently (e.g. wooden cabin vs. stone castle), producing different representations from the same sequence of calls — as long as client code talks to builders through a common interface.

**Director** (optional): extract the sequence of building-step calls into a separate director class that knows *which* steps to run in *what order* to build a particular configuration, while builders provide the step implementations. The director hides construction details from the client; the client associates a builder with a director, launches construction, and fetches the result from the builder.

## Structure
1. **Builder** — interface declaring construction steps common to all builders.
2. **Concrete Builders** — different implementations of the steps; may produce products that don't share a common interface.
3. **Products** — the resulting objects; products from different builders need not share a class hierarchy.
4. **Director** — defines the order of construction steps, enabling reuse of specific configurations.
5. **Client** — associates a builder with the director (usually once, via the director's constructor), or passes a builder to the director's production method to use a different builder per product.

## Pseudocode (cars + manuals)
`Car` and `Manual` are related but share no common interface. The `Builder` interface declares `reset`, `setSeats`, `setEngine`, `setTripComputer`, `setGPS`. `CarBuilder` assembles a `Car`; `CarManualBuilder` implements the same steps but *documents* each feature into a `Manual`. Because the products differ, each concrete builder exposes its own `getProduct()` (not on the shared interface). A `Director` offers routines like `constructSportsCar(builder)` that call the steps in a fixed order. The client picks a builder, passes it to the director, runs a routine, then fetches the result from the builder.

## Applicability
- Use to get rid of a **telescoping constructor** (many overloaded constructors with growing parameter lists). Build step by step using only the steps you need.
- Use when your code must create **different representations** of some product (e.g. stone vs. wooden houses) through similar steps that differ only in details.
- Use to construct **Composite trees** or other complex objects — steps can be deferred or called recursively to build object trees, and the unfinished product is never exposed mid-construction.

## How to Implement
1. Make sure you can clearly define the common construction steps for all representations.
2. Declare those steps in the base builder interface.
3. Create a concrete builder per representation and implement its steps. Add a result-fetching method (can't live on the interface unless all products share a hierarchy, because return types differ).
4. Consider a director class to encapsulate ways of constructing a product with the same builder.
5. Client creates both builder and director, passes the builder to the director before construction.
6. Obtain the result from the director only if all products follow one interface; otherwise fetch it from the builder.

## Pros and Cons
- ✓ Construct objects step-by-step, defer steps, or run steps recursively.
- ✓ Reuse the same construction code for various representations.
- ✓ Single Responsibility Principle: isolate complex construction code from the product's business logic.
- ✗ Overall code complexity increases since the pattern requires several new classes.

## Relations with Other Patterns
- Designs often start with **Factory Method** and evolve toward Abstract Factory, Prototype, or **Builder**.
- **Abstract Factory** creates families and returns the product immediately; Builder runs extra construction steps before returning.
- Use Builder to build complex **Composite** trees (recursive construction steps).
- Combine with **Bridge**: the director plays the abstraction, different builders the implementations.
- Abstract Factories, Builders, and **Prototypes** can all be implemented as **Singletons**.

## Code Examples
- [C#](../code-examples/csharp/Builder.cs)
- [Java](../code-examples/java/Builder.java)
- [TypeScript](../code-examples/typescript/Builder.ts)
- [C++](../code-examples/cpp/Builder.cpp)
- [Swift](../code-examples/swift/Builder.swift)
- [PHP](../code-examples/php/Builder.php)
- [Python](../code-examples/python/builder.py)
- [Go](../code-examples/go/builder.go)
- [Ruby](../code-examples/ruby/builder.rb)
- [Rust](../code-examples/rust/builder.rs)
