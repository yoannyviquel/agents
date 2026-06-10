# Design Principles

There is no single universal answer to what makes good software design — it depends on the type of application — but several universal principles help make architecture flexible, stable, and easy to understand. Most design patterns are based on these principles: Encapsulate What Varies, Program to an Interface, and Favor Composition Over Inheritance.

## Encapsulate What Varies

> Identify the aspects of your application that vary and separate them from what stays the same.

The main goal is to **minimize the effect caused by changes**. Imagine your program is a ship and changes are mines under the water; a struck ship sinks. By dividing the hull into independent compartments that can be sealed, a single hit damages only one compartment and the ship stays afloat. Likewise, isolating the parts of a program that vary into independent modules protects the rest of the code. The less time you spend making changes, the more time you have for implementing features.

### Encapsulation on a Method Level

On an e-commerce site, a `getOrderTotal` method calculates the grand total including taxes. Tax code is likely to change (rates depend on country/state/city; formulas change with new laws), so `getOrderTotal` would change often — even though its name suggests it shouldn't care how tax is calculated.

**Before** — tax calculation is mixed into the method:

```
method getOrderTotal(order) is
    total = 0
    foreach item in order.lineItems
        total += item.price * item.quantity
    if (order.country == "US")
        total += total * 0.07   // US sales tax
    else if (order.country == "EU")
        total += total * 0.20   // European VAT
    return total
```

**After** — extract the tax logic into a designated method:

```
method getOrderTotal(order) is
    total = 0
    foreach item in order.lineItems
        total += item.price * item.quantity
    total += total * getTaxRate(order.country)
    return total

method getTaxRate(country) is
    if (country == "US")  return 0.07   // US sales tax
    else if (country == "EU") return 0.20  // European VAT
    else return 0
```

Tax-related changes become isolated inside a single method. And if the tax logic grows too complicated, it's now easier to move it to a separate class.

### Encapsulation on a Class Level

Over time you might add responsibilities to a method that once did a simple thing. These additions bring their own helper fields and methods that blur the primary responsibility of the containing class. Extracting everything to a new class makes things clearer and simpler — for example, objects of the `Order` class can delegate all tax-related work to a special object that does just that, hiding the tax calculation from `Order`.

## Program to an Interface, Not an Implementation

> Program to an interface, not an implementation. Depend on abstractions, not on concrete classes.

A design is flexible enough if you can easily extend it without breaking existing code. (Analogy: a `Cat` that can eat *any food* is more flexible than one that can eat only sausages — you can still feed it sausages, but you can also extend its menu.)

To make two classes collaborate flexibly:

1. Determine what exactly one object needs from the other — which methods does it call?
2. Describe those methods in a new interface or abstract class.
3. Make the dependency class implement this interface.
4. Make the second class depend on the interface rather than the concrete class.

The connection becomes much more flexible. You may feel no immediate benefit — in fact the code becomes more complicated — but if this looks like a good extension point for extra functionality, or others may want to extend it here, go for it.

### Example

In a software-development-company simulator with various employee-type classes:

- **Before**: the `Company` class is tightly coupled to concrete employee classes.
- **Better**: extract a common `Employee` interface for all employee classes; now `Company` uses polymorphism, treating employees via the interface. But `Company` still depends on concrete employee classes, so introducing new company types that work with other employees would force overriding most of `Company`.
- **After**: declare the method for getting employees as **abstract**. Each concrete company subclass implements it differently, creating only the employees it needs. Now `Company` is independent of concrete employee classes; you can introduce new company and employee types while reusing the base company class, and extending it doesn't break existing client code.

This example is actually an application of the **Factory Method** pattern.

## Favor Composition Over Inheritance

Inheritance is the most obvious way to reuse code: create a common base class and move shared code into it. But it comes with caveats that often surface only after a program has tons of classes:

- A subclass **can't reduce the interface** of the superclass — you must implement all abstract methods even if unused.
- When **overriding** methods, the new behavior must stay compatible with the base, because subclass objects may be passed to code expecting the superclass.
- Inheritance **breaks encapsulation** of the superclass, exposing the parent's internal details to the subclass (and sometimes forcing the superclass to know about subclass details).
- Subclasses are **tightly coupled** to superclasses — any change in the superclass may break subclasses.
- Reusing code through inheritance can create **parallel inheritance hierarchies**. Inheritance works in a single dimension, but with two or more dimensions you must create many class combinations, bloating the hierarchy.

The alternative is **composition**. Inheritance represents an "is a" relationship (a car *is a* transport); composition represents a "has a" relationship (a car *has an* engine). This principle also applies to **aggregation** — a more relaxed variant where one object references another but doesn't manage its lifecycle (a car *has a* driver, but the driver may use another car or just walk).

### Example

A catalog app for a car manufacturer that makes both cars and trucks, each electric or gas, each with manual controls or autopilot:

- **Inheritance**: extending a class across several dimensions (cargo type x engine type x navigation type) leads to a **combinatorial explosion** of subclasses, with lots of duplicate code because a subclass can't extend two classes at once.
- **Composition**: extract each "dimension" of functionality into its own class hierarchy, and have car objects **delegate** behavior to those objects instead of implementing it themselves. Added benefit: you can **replace a behavior at runtime** — e.g. swap a car's engine object by assigning a different engine.

This structure resembles the **Strategy** pattern.
