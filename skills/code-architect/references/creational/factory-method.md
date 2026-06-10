# Factory Method
> *Provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created.*

**Category:** Creational
**Also known as:** Virtual Constructor

## Intent
Replace direct object construction calls (the `new` operator) with calls to a special *factory method*, so that subclasses can decide which concrete class to instantiate while client code only depends on a common product interface.

## Problem
Imagine a logistics app whose first version only handles transportation by truck, so most code is coupled to the `Truck` class. Adding `Ship` (sea logistics) would require changing the whole codebase, and each new transport type forces the same changes again — leaving code riddled with conditionals that switch behavior based on the transport class.

## Solution
Move construction out of client code into a factory method. Objects are still created with `new`, but from inside the factory method, and the returned objects are called *products*. Subclasses can override the factory method to change the class of products created.

Limitation: subclasses may return different product types only if those products share a common base class or interface, and the factory method's return type must be declared as that interface. E.g. `Truck` and `Ship` both implement `Transport` (declaring `deliver`); `RoadLogistics.createTransport()` returns trucks, `SeaLogistics.createTransport()` returns ships. Client code (the *creator*) treats every product as an abstract `Transport` and doesn't see the difference.

## Structure
1. **Product** — the interface common to all objects the creator and its subclasses can produce.
2. **Concrete Products** — the different implementations of the product interface.
3. **Creator** — declares the factory method returning new product objects (return type matches the product interface). The factory method may be `abstract` (forcing subclasses to implement it) or return a default product. Product creation is *not* the creator's primary responsibility — the creator usually holds core business logic relying on products; the factory method decouples that logic from concrete product classes. The factory method may also return cached/pooled objects rather than always creating new ones.
4. **Concrete Creators** — override the base factory method to return a different type of product.

## Pseudocode (cross-platform UI)
A base `Dialog` class renders a window using UI elements. `Dialog` declares an abstract `createButton(): Button` factory method and a `render()` method that uses the produced button. `WindowsDialog` and `WebDialog` override `createButton()` to return `WindowsButton` / `HTMLButton`. The `Application` picks the concrete dialog at initialization based on configuration/environment, then works only through the base `Dialog` interface. Adding more UI factory methods to `Dialog` gradually moves you toward Abstract Factory.

## Applicability
- Use when you **don't know beforehand the exact types and dependencies** of the objects your code should work with — it separates construction code from usage, so you can add a product type by creating a new creator subclass.
- Use when you want to **let users of your library/framework extend its internal components** — funnel component construction into a single overridable factory method.
- Use when you want to **save system resources by reusing existing objects** instead of rebuilding them (object pool / cache logic naturally lives in a factory method, unlike a constructor which must always return a new object).

## How to Implement
1. Make all products follow the same interface declaring methods meaningful to every product.
2. Add an empty factory method in the creator class with the product-interface return type.
3. Find all product constructor calls in the creator's code and replace them with calls to the factory method, extracting the construction code into it (a temporary parameter may control the type returned).
4. Create a creator subclass per product type; override the factory method and move the relevant construction code there.
5. If there are too many product types to subclass each, reuse the control parameter from the base class in subclasses.
6. If the base factory method ends up empty, make it abstract; if something remains, make it the default behavior.

## Pros and Cons
- ✓ Avoids tight coupling between the creator and the concrete products.
- ✓ Single Responsibility Principle: product creation code moves to one place, easier to support.
- ✓ Open/Closed Principle: introduce new product types without breaking existing client code.
- ✗ Code can become more complicated since you may need many new subclasses. Best applied when introducing the pattern into an existing creator hierarchy.

## Relations with Other Patterns
- Many designs start with Factory Method (simpler, customizable via subclasses) and evolve toward **Abstract Factory**, **Prototype**, or **Builder** (more flexible but more complicated).
- **Abstract Factory** classes are often based on a set of factory methods, but you can also use **Prototype** to compose them.
- Use with **Iterator** to let collection subclasses return compatible iterator types.
- **Prototype** isn't based on inheritance (no inheritance drawbacks) but needs complicated initialization; Factory Method is inheritance-based but needs no initialization step.
- Factory Method is a specialization of **Template Method**, and may serve as a step within a large template method.

## Code Examples
- [C#](../code-examples/csharp/FactoryMethod.cs)
- [Java](../code-examples/java/FactoryMethod.java)
- [TypeScript](../code-examples/typescript/FactoryMethod.ts)
- [C++](../code-examples/cpp/FactoryMethod.cpp)
- [Swift](../code-examples/swift/FactoryMethod.swift)
- [PHP](../code-examples/php/FactoryMethod.php)
- [Python](../code-examples/python/factory_method.py)
- [Go](../code-examples/go/factory_method.go)
- [Ruby](../code-examples/ruby/factory_method.rb)
- [Rust](../code-examples/rust/factory_method.rs)
