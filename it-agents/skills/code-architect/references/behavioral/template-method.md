# Template Method
> *Defines the skeleton of an algorithm in the superclass but lets subclasses override specific steps of the algorithm without changing its structure.*

**Category:** Behavioral

## Intent
Put the invariant structure of an algorithm into a base-class method that calls a series of steps, letting subclasses override individual steps without altering the algorithm's overall shape.

## Problem
A data-mining app analyzes corporate documents in various formats (DOC, then CSV, then PDF) and extracts data uniformly. The three processing classes share a lot of similar code: format handling differs, but data processing and analysis are almost identical. You want to remove the duplication while keeping the algorithm structure. The client code also has conditionals choosing behavior by the processing object's class — a common base would let polymorphism replace those conditionals.

## Solution
Break the algorithm into steps, turn each into a method, and put a series of calls to these methods inside a single **template method**. Steps may be `abstract` or have a default implementation. To use the algorithm, the client provides a subclass implementing the abstract steps and overriding optional ones — but never the template method itself. For the data miner, a base class defines a template method calling document-processing steps; format-specific steps (open/close file, extract/parse) stay per-subclass, while similar steps (analyze raw data, compose reports) move up into the base class.

Three kinds of steps:
- **abstract steps** — every subclass must implement them.
- **optional steps** — have a default implementation, can be overridden.
- **hooks** — optional steps with an empty body, placed before/after crucial steps as extra extension points; the algorithm works even if a hook isn't overridden.

## Real-World Analogy
Mass housing construction: a standard architectural plan has extension points letting an owner adjust details (foundation, framing, walls, plumbing, wiring) so each house differs slightly while following the same plan.

## Structure
1. **Abstract Class** — declares the algorithm's step methods and the template method that calls them in a specific order; steps may be abstract or have defaults.
2. **Concrete Classes** — override the steps (abstract or optional) but not the template method itself.

## Pseudocode (game AI)
`GameAI` defines the template method `turn()` calling `collectResources()`, `buildStructures()`, `buildUnits()`, `attack()`. Some steps have a base implementation (`collectResources`), some are abstract (`buildStructures`, `buildUnits`). `attack()` is itself a small template using abstract `sendScouts`/`sendWarriors`. `OrcsAI` implements all abstract operations; `MonstersAI` overrides defaults (monsters don't collect resources, build structures, or build units). Adding a race means a new subclass overriding the relevant methods, never the template method.

## Applicability
- Use to let clients **extend only particular steps** of an algorithm, not its whole structure — turn a monolithic algorithm into individual, extendable steps within a fixed superclass structure.
- Use when several classes contain **almost identical algorithms with minor differences** — convert to a template method and pull shared steps up into the superclass, leaving varying code in subclasses.

## How to Implement
1. Analyze the algorithm to break it into steps; determine which are common to all subclasses and which are always unique.
2. Create the abstract base class with the template method and the step methods; outline the structure in the template method (consider making it `final` to prevent overriding).
3. It's fine if all steps are abstract; some may benefit from a default implementation.
4. Consider adding hooks between crucial steps.
5. Create a concrete subclass per algorithm variation, implementing abstract steps and overriding optional ones.

## Pros and Cons
- ✓ Let clients override only certain parts of a large algorithm, shielding them from changes to other parts.
- ✓ Pull duplicate code into a superclass.
- ✗ Some clients may be limited by the provided algorithm skeleton.
- ✗ You might violate the Liskov Substitution Principle by suppressing a default step implementation in a subclass.
- ✗ Template methods get harder to maintain the more steps they have.

## Relations with Other Patterns
- **Factory Method** is a specialization of Template Method; a factory method may also serve as a step within a large template method.
- **Template Method** is inheritance-based (alter algorithm parts by subclassing — static, class level); **Strategy** is composition-based (swap behaviors at runtime — object level).

## Code Examples
- [C#](../code-examples/csharp/TemplateMethod.cs)
- [Java](../code-examples/java/TemplateMethod.java)
- [TypeScript](../code-examples/typescript/TemplateMethod.ts)
- [C++](../code-examples/cpp/TemplateMethod.cpp)
- [Swift](../code-examples/swift/TemplateMethod.swift)
- [PHP](../code-examples/php/TemplateMethod.php)
- [Python](../code-examples/python/template_method.py)
- [Go](../code-examples/go/template_method.go)
- [Ruby](../code-examples/ruby/template_method.rb)
- [Rust](../code-examples/rust/template_method.rs)
