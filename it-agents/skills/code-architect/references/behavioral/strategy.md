# Strategy
> *Lets you define a family of algorithms, put each of them into a separate class, and make their objects interchangeable.*

**Category:** Behavioral

## Intent
Extract a family of interchangeable algorithms into separate strategy classes behind a common interface, so the context can delegate to (and swap) an algorithm at runtime without depending on its implementation.

## Problem
A navigation app first builds routes over roads, then walking routes, then public transport, with cyclist and tourist-attraction routing planned. Each new routing algorithm doubles the main navigator class, making it hard to maintain — any change to one algorithm risks breaking working code, and teammates spend time resolving merge conflicts editing the same huge class.

## Solution
Extract each algorithm into its own **strategy** class. The original class — the **context** — holds a reference to a strategy and delegates the work to it instead of executing it itself. The context doesn't choose the algorithm; the client passes the desired strategy in. The context works with all strategies through a generic interface exposing a single method to trigger the algorithm, so it stays independent of concrete strategies — you can add/modify algorithms without touching the context or other strategies. In the nav app, each routing algorithm becomes a class with a `buildRoute(origin, destination)` method; the navigator just renders the returned checkpoints and can switch the active strategy via a setter.

## Real-World Analogy
Getting to the airport: catch a bus, order a cab, or ride a bicycle — transportation *strategies* chosen by budget or time constraints.

## Structure
1. **Context** — maintains a reference to a concrete strategy and communicates only via the strategy interface.
2. **Strategy** — interface common to all concrete strategies, declaring the method the context uses to execute the algorithm.
3. **Concrete Strategies** — implement different variations of the algorithm.
4. The context calls the execution method on the linked strategy whenever it needs the algorithm, without knowing its type or how it works.
5. **Client** — creates a specific strategy and passes it to the context; the context's setter lets clients replace the strategy at runtime.

## Pseudocode (arithmetic)
`Strategy` declares `execute(a, b)`. `ConcreteStrategyAdd`, `ConcreteStrategySubtract`, `ConcreteStrategyMultiply` implement it. `Context` holds a `strategy` reference, exposes `setStrategy(...)`, and `executeStrategy(a, b)` delegates to `strategy.execute(a, b)`. The client reads the desired action, sets the matching strategy on the context, and runs it — the context never knows which concrete strategy it holds.

## Applicability
- Use to **use different variants of an algorithm** within an object and switch between them at runtime.
- Use when you have **many similar classes differing only in how they execute some behavior** — extract the varying behavior into a strategy hierarchy and merge the originals.
- Use to **isolate business logic from algorithm implementation details** that aren't important to that logic.
- Use when a class has a **massive conditional** switching between variants of the same algorithm — replace it with strategies behind one interface.

## How to Implement
1. In the context, identify a frequently-changing algorithm (or a massive conditional selecting algorithm variants).
2. Declare the strategy interface common to all variants.
3. Extract each algorithm into its own class implementing the interface.
4. Add a strategy-reference field and a setter to the context; the context works with the strategy only via the interface (it may expose an interface for the strategy to access its data).
5. Clients associate the context with a suitable strategy.

## Pros and Cons
- ✓ Swap algorithms used inside an object at runtime.
- ✓ Isolate algorithm implementation details from the code that uses it.
- ✓ Replace inheritance with composition.
- ✓ Open/Closed Principle: introduce new strategies without changing the context.
- ✗ Overkill if you have only a couple of rarely-changing algorithms.
- ✗ Clients must know the differences between strategies to pick the right one.
- ✗ Modern functional-type support can implement algorithm variants as anonymous functions, avoiding extra classes and interfaces.

## Relations with Other Patterns
- **Bridge**, **State**, **Strategy** (and to a degree **Adapter**) share composition-based structures but solve different problems.
- **Command** and Strategy both parameterize an object with an action, but Command converts an operation into an object (deferred/queued/logged), while Strategy describes interchangeable ways of doing the same thing in one context.
- **Decorator** changes an object's *skin*; Strategy changes its *guts*.
- **Template Method** is inheritance-based (alter algorithm parts by subclassing — static, class level); Strategy is composition-based (swap behaviors at runtime — object level).
- **State** can be seen as an extension of Strategy: both delegate to helper objects, but Strategy keeps them independent/unaware, while State lets concrete states alter the context at will.

## Code Examples
- [C#](../code-examples/csharp/Strategy.cs)
- [Java](../code-examples/java/Strategy.java)
- [TypeScript](../code-examples/typescript/Strategy.ts)
- [C++](../code-examples/cpp/Strategy.cpp)
- [Swift](../code-examples/swift/Strategy.swift)
- [PHP](../code-examples/php/Strategy.php)
- [Python](../code-examples/python/strategy.py)
- [Go](../code-examples/go/strategy.go)
- [Ruby](../code-examples/ruby/strategy.rb)
- [Rust](../code-examples/rust/strategy.rs)
