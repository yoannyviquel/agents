# Decorator
> *Lets you attach new behaviors to objects by placing these objects inside special wrapper objects that contain the behaviors.*

**Category:** Structural
**Also known as:** Wrapper

## Intent
Add responsibilities to an object dynamically by wrapping it in one or more wrapper objects that share its interface, as a flexible alternative to subclassing.

## Problem
A notification library starts with a `Notifier` class that sends email to a list of recipients. Users then want SMS, Facebook, Slack notifications — and combinations of them. Implementing each type and each combination as a subclass causes a combinatorial explosion that bloats both the library and the client code.

## Solution
Inheritance has caveats: it's static (can't change behavior at runtime) and most languages allow only one parent. Use **Aggregation/Composition** instead — one object references another and delegates work, so you can swap the helper at runtime and combine behaviors from multiple objects.

A *Wrapper* implements the same interface as its target and delegates every request to it, optionally doing something before or after. It becomes a true *decorator* when its reference field accepts any object following that interface, letting you cover an object in multiple wrappers and stack their combined behavior. For notifications: keep email in the base `Notifier`, turn the other channels into decorators, and stack them; the last decorator is what the client uses, and since all share the interface, the rest of the client code doesn't care whether it holds a plain or decorated notifier.

> *Aggregation*: A contains B; B can live without A. *Composition*: A consists of B; A manages B's life cycle; B can't live without A.

## Real-World Analogy
Wearing clothes: a sweater, then a jacket, then a raincoat. Each garment "extends" your behavior, isn't part of you, and can be removed when not needed.

## Structure
1. **Component** — the common interface for both wrappers and wrapped objects.
2. **Concrete Component** — the class being wrapped, defining the basic behavior decorators can alter.
3. **Base Decorator** — has a field referencing a wrapped object, typed as the component interface (so it can hold concrete components *and* decorators); delegates all operations to the wrapped object.
4. **Concrete Decorators** — add extra behavior dynamically by overriding base-decorator methods and running their behavior before/after calling the parent method.
5. **Client** — wraps components in multiple layers, working with all objects through the component interface.

## Pseudocode (compression + encryption)
`DataSource` declares `writeData`/`readData`. `FileDataSource` is the concrete component. `DataSourceDecorator` holds a `wrappee: DataSource` and delegates. `EncryptionDecorator` and `CompressionDecorator` extend it: on write they encrypt/compress before delegating; on read they reverse it after delegating. The client builds a stack like `Encryption > Compression > FileDataSource`. `ApplicationConfigurator` assembles the stack at runtime based on `enabledEncryption`/`enabledCompression` flags, while `SalaryManager` works only through the `DataSource` interface, oblivious to storage specifics.

## Applicability
- Use to **assign extra behaviors at runtime** without breaking the code that uses the objects — structure logic into layers and compose objects with various combinations.
- Use when extending behavior **via inheritance is awkward or impossible** (e.g. a `final` class can only be reused by wrapping it).

## How to Implement
1. Ensure your domain can be a primary component with multiple optional layers over it.
2. Find methods common to the primary component and the optional layers; declare them on a component interface.
3. Create a concrete component with the base behavior.
4. Create a base decorator with a component-typed field for the wrapped object; delegate all work to it.
5. Make all classes implement the component interface.
6. Create concrete decorators extending the base decorator; each runs its behavior before/after the parent call.
7. The client is responsible for creating decorators and composing them as needed.

## Pros and Cons
- ✓ Extend an object's behavior without a new subclass.
- ✓ Add or remove responsibilities at runtime.
- ✓ Combine several behaviors by stacking multiple decorators.
- ✓ Single Responsibility Principle: split a monolithic class of many behavior variants into smaller classes.
- ✗ Hard to remove a specific wrapper from the stack.
- ✗ Hard to make decorator behavior independent of its order in the stack.
- ✗ The layer-configuration code can look ugly.

## Relations with Other Patterns
- **Adapter** gives a *different* interface; **Decorator** keeps or *enhances* the interface and supports recursive composition (Adapter doesn't); **Proxy** keeps the *same* interface.
- **Chain of Responsibility** and Decorator have similar structures (recursive composition), but CoR handlers act independently and may stop the request, while decorators extend behavior without breaking the request flow.
- **Composite** and Decorator share structure; a Decorator is a Composite with one child that *adds* responsibilities rather than *summing up* children; they can cooperate.
- Heavy Composite + Decorator use benefits from **Prototype** (clone instead of rebuild).
- **Decorator** changes the *skin* of an object; **Strategy** changes its *guts*.
- **Decorator** and **Proxy** look similar but differ in intent: a Proxy usually manages its service's life cycle itself, whereas a decorator stack is always controlled by the client.

## Code Examples
- [C#](../code-examples/csharp/Decorator.cs)
- [Java](../code-examples/java/Decorator.java)
- [TypeScript](../code-examples/typescript/Decorator.ts)
- [C++](../code-examples/cpp/Decorator.cpp)
- [Swift](../code-examples/swift/Decorator.swift)
- [PHP](../code-examples/php/Decorator.php)
- [Python](../code-examples/python/decorator.py)
- [Go](../code-examples/go/decorator.go)
- [Ruby](../code-examples/ruby/decorator.rb)
- [Rust](../code-examples/rust/decorator.rs)
