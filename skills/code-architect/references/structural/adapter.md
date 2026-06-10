# Adapter
> *Allows objects with incompatible interfaces to collaborate.*

**Category:** Structural
**Also known as:** Wrapper

## Intent
Provide a special object — the *adapter* — that converts the interface of one object so another object can work with it.

## Problem
A stock-market monitoring app downloads data in XML and renders charts. You want to integrate a smart 3rd-party analytics library, but it only accepts JSON. You can't use it "as is" (incompatible format), and you can't safely change the library — it might break dependent code, or you may not even have its source.

## Solution
Create an adapter that wraps one object to hide the conversion happening behind the scenes (the wrapped object isn't even aware of the adapter). Adapters can convert data formats *and* let objects with different interfaces collaborate:
1. The adapter gets an interface compatible with one of the existing objects.
2. The existing object calls the adapter's methods through that interface.
3. On receiving a call, the adapter passes the request to the second object in the format and order it expects.

A two-way adapter that converts calls in both directions is sometimes possible. For the stock app: build XML-to-JSON adapters for each analytics class you use, and talk to the library only through them.

## Real-World Analogy
A power-plug adapter: travelling from the US to Europe, your US plug won't fit a German socket. An adapter with a US-style socket and a European-style plug bridges the two standards.

## Structure
**Object adapter** (composition — works in all languages):
1. **Client** — contains the existing business logic.
2. **Client Interface** — the protocol other classes must follow to collaborate with the client.
3. **Service** — a useful (often 3rd-party / legacy) class with an incompatible interface the client can't use directly.
4. **Adapter** — implements the client interface *and* wraps the service object; it receives client calls and translates them into calls the service understands.
5. Client code stays decoupled from the concrete adapter as long as it works via the client interface, so you can add adapter types without breaking it.

**Class adapter** (inheritance — only in languages with multiple inheritance, e.g. C++): the adapter inherits from both client and service; adaptation happens in overridden methods.

## Pseudocode (square pegs / round holes)
`RoundHole.fits(peg: RoundPeg)` compares radii. `SquarePeg` is incompatible. `SquarePegAdapter extends RoundPeg`, holds a `SquarePeg`, and overrides `getRadius()` to return `peg.getWidth() * sqrt(2) / 2` (the radius of the smallest circle accommodating the square). Now a square peg wrapped in the adapter can be tested against a round hole.

## Applicability
- Use when you want to use an existing class whose **interface isn't compatible** with the rest of your code — a middle-layer translator between your code and a legacy/3rd-party/odd-interface class.
- Use to **reuse several existing subclasses** that lack a common feature which can't be added to the superclass: put the missing feature into an adapter wrapping those objects (target classes need a common interface). This resembles **Decorator**.

## How to Implement
1. Ensure you have at least two classes with incompatible interfaces (an unchangeable service class and one or more clients that would benefit from it).
2. Declare the client interface describing how clients talk to the service.
3. Create the adapter class following the client interface (methods empty for now).
4. Add a field to the adapter storing a reference to the service object (usually set via constructor).
5. Implement each client-interface method in the adapter, delegating real work to the service and handling only interface/data conversion.
6. Clients use the adapter via the client interface, so you can change/extend adapters without touching client code.

## Pros and Cons
- ✓ Single Responsibility Principle: separates interface/data conversion from primary business logic.
- ✓ Open/Closed Principle: introduce new adapter types without breaking client code.
- ✗ Overall complexity increases (new interfaces and classes). Sometimes it's simpler to just change the service class to match your code.

## Relations with Other Patterns
- **Bridge** is usually designed up-front to develop parts independently; Adapter is commonly applied to an *existing* app to make incompatible classes work together.
- **Adapter** provides a *different* interface; **Decorator** keeps or extends the interface and supports recursive composition (Adapter doesn't); **Proxy** keeps the *same* interface.
- **Facade** defines a *new* interface for existing objects, while Adapter makes an existing interface usable; Adapter wraps one object, Facade wraps a whole subsystem.
- **Bridge**, **State**, **Strategy** (and to a degree Adapter) have similar structures — all composition-based — but solve different problems.

## Code Examples
- [C#](../code-examples/csharp/Adapter.cs)
- [Java](../code-examples/java/Adapter.java)
- [TypeScript](../code-examples/typescript/Adapter.ts)
- [C++](../code-examples/cpp/Adapter.cpp)
- [Swift](../code-examples/swift/Adapter.swift)
- [PHP](../code-examples/php/Adapter.php)
- [Python](../code-examples/python/adapter.py)
- [Go](../code-examples/go/adapter.go)
- [Ruby](../code-examples/ruby/adapter.rb)
- [Rust](../code-examples/rust/adapter.rs)
