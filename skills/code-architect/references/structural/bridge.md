# Bridge
> *Lets you split a large class or a set of closely related classes into two separate hierarchies — abstraction and implementation — which can be developed independently of each other.*

**Category:** Structural

## Intent
Decouple an abstraction from its implementation so the two can vary independently, replacing an exploding multi-dimensional inheritance hierarchy with composition between two hierarchies.

## Problem
A `Shape` hierarchy with `Circle` and `Square` must also support colors (`Red`, `Blue`). Combining both dimensions through inheritance forces four classes (`BlueCircle`, `RedSquare`, …) and grows in geometric progression — adding a shape or a color multiplies the classes. The root cause: extending in two independent dimensions (form × color) via inheritance.

## Solution
Switch from inheritance to **object composition**: extract one dimension into a separate class hierarchy, and have the original class reference an object of the new hierarchy. Extract color into a `Color` hierarchy (`Red`, `Blue`); `Shape` holds a reference to a color object and delegates color work to it. That reference is the *bridge*. Now adding colors doesn't touch the shape hierarchy, and vice versa.

**Abstraction and Implementation** (GoF terms):
- **Abstraction** (a.k.a. interface) — a high-level control layer that does no real work itself; it delegates to the implementation layer. (Not the same as language interfaces/abstract classes.)
- **Implementation** (a.k.a. platform) — the lower layer doing the actual work. Example: a GUI (abstraction) calling an OS API (implementation). You can extend such an app in two independent directions: several GUIs and several APIs. Bridge splits them into two hierarchies so the GUI can work under Windows/Linux unchanged.

## Structure
1. **Abstraction** — high-level control logic; relies on the implementation object for low-level work.
2. **Implementation** — interface common to all concrete implementations; the abstraction communicates only through these methods. The abstraction usually declares complex behaviors built from the implementation's primitive operations.
3. **Concrete Implementations** — platform-specific code.
4. **Refined Abstractions** — variants of control logic, working with implementations via the general interface.
5. **Client** — works with the abstraction, but is responsible for linking an abstraction object to one implementation object.

## Pseudocode (devices + remotes)
`Device` is the implementation interface (`isEnabled`, `enable`, `disable`, `getVolume`, `setVolume`, `getChannel`, `setChannel`); `Tv` and `Radio` implement it. `RemoteControl` is the abstraction holding a `device` reference and offering `togglePower`, `volumeUp/Down`, `channelUp/Down` built from device primitives. `AdvancedRemoteControl` extends it with `mute()`. Client links a remote to a device via the remote's constructor; remotes and devices evolve independently.

## Applicability
- Use to **divide and organize a monolithic class** that has several variants of some functionality (e.g. works with various database servers) — split it into independent hierarchies you can change separately.
- Use when you need to **extend a class along several orthogonal (independent) dimensions** — extract a hierarchy per dimension and delegate.
- Use when you need to **switch implementations at runtime** — replacing the implementation object is as easy as assigning a field. (This is why Bridge is often confused with **Strategy**, but the intents differ.)

## How to Implement
1. Identify the orthogonal dimensions (abstraction/platform, domain/infrastructure, front-end/back-end, interface/implementation).
2. Define the operations the client needs in the base abstraction class.
3. Determine operations available on all platforms; declare the ones the abstraction needs in the implementation interface.
4. Create concrete implementation classes per platform, all following the implementation interface.
5. Add an implementation-type reference field in the abstraction and delegate most work to it.
6. For multiple variants of high-level logic, create refined abstractions extending the base abstraction.
7. Client passes an implementation object to the abstraction's constructor, then works only with the abstraction.

## Pros and Cons
- ✓ Create platform-independent classes and apps.
- ✓ Client code works with high-level abstractions, not exposed to platform details.
- ✓ Open/Closed Principle: introduce new abstractions and implementations independently.
- ✓ Single Responsibility Principle: high-level logic in the abstraction, platform details in the implementation.
- ✗ Applying it to a highly cohesive class may make the code more complicated.

## Relations with Other Patterns
- **Bridge** is usually designed up-front; **Adapter** makes existing incompatible classes work together in an existing app.
- **Bridge**, **State**, **Strategy** (and to a degree Adapter) share composition-based structures but solve different problems.
- Use **Abstract Factory** with Bridge when some abstractions only work with specific implementations — the factory encapsulates those relations.
- Combine **Builder** with Bridge: the director plays the abstraction, different builders the implementations.

## Code Examples
- [C#](../code-examples/csharp/Bridge.cs)
- [Java](../code-examples/java/Bridge.java)
- [TypeScript](../code-examples/typescript/Bridge.ts)
- [C++](../code-examples/cpp/Bridge.cpp)
- [Swift](../code-examples/swift/Bridge.swift)
- [PHP](../code-examples/php/Bridge.php)
- [Python](../code-examples/python/bridge.py)
- [Go](../code-examples/go/bridge.go)
- [Ruby](../code-examples/ruby/bridge.rb)
- [Rust](../code-examples/rust/bridge.rs)
