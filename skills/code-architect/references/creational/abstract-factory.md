# Abstract Factory
> *Lets you produce families of related objects without specifying their concrete classes.*

**Category:** Creational

## Intent
Provide an interface for creating whole *families* of related products, so a client can produce a consistent set of objects (e.g. matching UI controls, matching furniture) without depending on their concrete classes.

## Problem
A furniture shop simulator has a family of related products (`Chair` + `Sofa` + `CoffeeTable`) available in several variants (`Modern`, `Victorian`, `ArtDeco`). You need to create individual objects so they *match* others of the same family — customers get mad receiving a Modern sofa with Victorian chairs. You also don't want to change existing code each time vendors add new products or variants.

## Solution
1. Explicitly declare an interface for each distinct product of the family (`Chair`, `Sofa`, `CoffeeTable`); make all variants implement those interfaces.
2. Declare the **Abstract Factory** — an interface with creation methods for every product in the family (`createChair`, `createSofa`, `createCoffeeTable`) returning the abstract product types.
3. For each variant, create a separate **Concrete Factory** implementing the abstract factory (e.g. `ModernFurnitureFactory` produces only `ModernChair`, `ModernSofa`, `ModernCoffeeTable`).

Client code works with factories and products only via their abstract interfaces, so you can swap the factory (and thus the product variant) without breaking the client. The app usually creates a concrete factory at initialization, choosing the type from configuration/environment.

## Structure
1. **Abstract Products** — interfaces for a set of distinct but related products forming a family.
2. **Concrete Products** — implementations of abstract products, grouped by variant; each abstract product must be implemented in every variant.
3. **Abstract Factory** — interface declaring creation methods for all abstract products.
4. **Concrete Factories** — implement those creation methods; each corresponds to one variant and creates only that variant's products.
5. Although concrete factories instantiate concrete products, their creation-method signatures return the *abstract* products, so client code stays decoupled from specific variants.

## Pseudocode (cross-platform UI)
`GUIFactory` declares `createButton(): Button` and `createCheckbox(): Checkbox`. `WinFactory` and `MacFactory` implement it, producing Windows / macOS variants. `Button` and `Checkbox` are abstract product interfaces with `paint()`. The `Application` receives a `GUIFactory` in its constructor and builds UI through it. `ApplicationConfigurator.main()` reads config, picks `WinFactory` or `MacFactory`, and passes it to the application — so adding a new OS variant only means adding a factory + products and tweaking initialization.

## Applicability
- Use when your code must work with **various families of related products** but you don't want it to depend on their concrete classes (unknown beforehand, or for future extensibility). It guarantees products obtained from one factory are compatible with each other.
- Consider it when a class has a set of factory methods that **blur its primary responsibility** — extract them into a standalone abstract factory.

## How to Implement
1. Map a matrix of distinct product *types* vs. product *variants*.
2. Declare abstract product interfaces for all types; make concrete products implement them.
3. Declare the abstract factory interface with creation methods for all abstract products.
4. Implement one concrete factory class per variant.
5. Add factory initialization code that instantiates the right concrete factory (per config/environment) and passes it to all classes that construct products.
6. Replace every direct product constructor call with a call to the matching creation method on the factory.

## Pros and Cons
- ✓ You're sure the products from a factory are compatible with each other.
- ✓ Avoids tight coupling between concrete products and client code.
- ✓ Single Responsibility Principle: product creation centralized.
- ✓ Open/Closed Principle: introduce new product variants without breaking client code.
- ✗ Code can become more complicated than necessary because many new interfaces and classes are introduced.

## Relations with Other Patterns
- Designs often start with **Factory Method** and evolve toward Abstract Factory, Prototype, or Builder.
- **Builder** constructs complex objects step by step; Abstract Factory creates families and returns the product immediately.
- Abstract Factory classes are often built on **Factory Methods**, but can also use **Prototype** to compose them.
- Can serve as an alternative to **Facade** when you only want to hide how subsystem objects are created.
- Works with **Bridge** when some Bridge abstractions only pair with specific implementations — the factory hides those relations.
- Abstract Factories, **Builders**, and **Prototypes** can all be implemented as **Singletons**.

## Code Examples
- [C#](../code-examples/csharp/AbstractFactory.cs)
- [Java](../code-examples/java/AbstractFactory.java)
- [TypeScript](../code-examples/typescript/AbstractFactory.ts)
- [C++](../code-examples/cpp/AbstractFactory.cpp)
- [Swift](../code-examples/swift/AbstractFactory.swift)
- [PHP](../code-examples/php/AbstractFactory.php)
- [Python](../code-examples/python/abstract_factory.py)
- [Go](../code-examples/go/abstract_factory.go)
- [Ruby](../code-examples/ruby/abstract_factory.rb)
- [Rust](../code-examples/rust/abstract_factory.rs)
