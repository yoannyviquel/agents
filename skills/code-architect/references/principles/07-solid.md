# SOLID Principles

SOLID is a mnemonic for five design principles — introduced by Robert Martin in *Agile Software Development, Principles, Patterns, and Practices* — intended to make software designs more understandable, flexible, and maintainable.

> Used mindlessly, these principles can cause more harm than good: applying them may make architecture more complicated than it should be. No successful product applies all of them at the same time everywhere. Strive for them, but stay pragmatic and don't treat them as dogma.

## Single Responsibility Principle (SRP)

> A class should have just one reason to change.

Make every class responsible for a single part of the software's functionality, and keep that responsibility entirely encapsulated within (hidden inside) the class. The main goal is **reducing complexity**. You don't need a sophisticated design for a 200-line program — just make a dozen methods pretty.

Real problems emerge as the program grows: classes become so big you can't remember their details, code navigation crawls, and the number of entities overflows your mental stack. Worse, if a class does too many things, you must change it every time one of those things changes, risking breakage in parts you didn't intend to touch.

**Example**: an `Employee` class has several reasons to change — managing employee data, and the format of the timesheet report (which may change over time). Move the timesheet-printing behavior into a separate class; this also lets you move other report-related stuff there.

## Open/Closed Principle (OCP)

> Classes should be open for extension but closed for modification.

The main idea is to keep existing code from breaking when you implement new features.

- A class is **open** if you can extend it — produce a subclass, add methods or fields, override behavior. Some languages let you restrict extension with keywords like `final`, after which a class is no longer open.
- A class is **closed** (or *complete*) if it's 100% ready to be used by other classes, with a clearly defined interface that won't change.

A class can be both open (for extension) and closed (for modification) at once. If a class is already developed, tested, reviewed, and used, changing its code is risky; instead, create a subclass and override the parts you want different — achieving your goal without breaking existing clients.

This principle isn't meant for all changes: if there's a bug in the class, just fix it directly — don't create a subclass. A child class shouldn't be responsible for the parent's issues.

**Example**: an e-commerce `Order` class with all shipping methods hardcoded inside it forces you to change `Order` (risking breakage) whenever you add a shipping method. Apply the **Strategy** pattern: extract shipping methods into separate classes with a common `Shipping` interface. To add a new method, derive a new class from `Shipping` without touching `Order`. As a bonus, you can move delivery-time calculation to the more relevant classes (per SRP).

## Liskov Substitution Principle (LSP)

> When extending a class, you should be able to pass objects of the subclass in place of objects of the parent class without breaking the client code.

The subclass should remain compatible with the superclass's behavior; when overriding a method, **extend** the base behavior rather than replacing it. LSP is critical for libraries and frameworks because your classes are used by people whose code you can't access or change. Unlike other principles, it has a formal checklist for subclasses and their methods:

- **Parameter types** in a subclass method should **match or be more abstract** than those in the superclass method. *Good*: overriding `feed(Cat c)` as `feed(Animal c)` still feeds any cat the client passes. *Bad*: restricting it to `feed(BengalCat c)` won't serve generic cats, breaking the client.
- **Return types** in a subclass method should **match or be a subtype** of the superclass return type (the inverse of the parameter rule). *Good*: overriding `buyCat(): Cat` as `buyCat(): BengalCat` — still a cat. *Bad*: `buyCat(): Animal` returns an unknown generic animal that doesn't fit a cat-shaped structure. (Dynamic-typing anti-example: the base returns a string, the override returns a number.)
- A subclass method **shouldn't throw exception types** the base method isn't expected to throw — they should match or be subtypes. Client try-catch blocks target specific exception types; an unexpected one slips through and crashes the app. (In statically typed languages like Java and C#, these rules are enforced by the compiler.)
- A subclass **shouldn't strengthen pre-conditions** — e.g. if the base accepts any `int`, the subclass shouldn't reject negatives, since client code that passed negatives would now break.
- A subclass **shouldn't weaken post-conditions** — e.g. if the base always closes database connections on return, a subclass that leaves them open (for reuse) can leave ghost connections if the client terminates right after the call.
- **Invariants of a superclass must be preserved.** Invariants are conditions in which an object makes sense (a cat has four legs, a tail, the ability to meow). They may be defined explicitly via contracts/assertions, or implied by unit tests and client expectations — making this the easiest rule to violate. The safest way to extend a class is to add new fields and methods without touching existing members (though not always feasible).
- A subclass **shouldn't change values of private fields** of the superclass. This is possible via reflection in some languages, and in languages like Python and JavaScript that don't protect private members at all.

**Example**: a document hierarchy where a `ReadOnlyDocuments` subclass overrides `save` to throw an exception (the base method has no such restriction). This breaks clients unless they check document type before saving, and it also violates OCP (clients become dependent on concrete document classes). **Fix**: redesign the hierarchy so the read-only document is the **base class**, and the writable document is a subclass that *extends* it by adding the saving behavior.

## Interface Segregation Principle (ISP)

> Clients shouldn't be forced to depend on methods they do not use.

Make interfaces narrow enough that client classes don't implement behaviors they don't need. Break down "fat" interfaces into more granular, specific ones — otherwise a change to a fat interface breaks even clients that don't use the changed methods. Since a class can implement many interfaces (even if it can extend only one superclass), there's no need to cram unrelated methods into one interface.

**Example**: a library integrating apps with cloud providers initially supported only Amazon Cloud and covered its full feature set. When adding another provider, most interfaces proved too wide — some methods describe features other providers lack. Putting stubs there isn't pretty; instead, **break the interface into parts**. Classes able to implement the original can implement several refined interfaces; others implement only the ones that make sense for them.

> You can go too far: don't divide an interface that's already quite specific. More interfaces means more complex code — keep the balance.

## Dependency Inversion Principle (DIP)

> High-level classes shouldn't depend on low-level classes. Both should depend on abstractions. Abstractions shouldn't depend on details. Details should depend on abstractions.

Two levels of classes are usually distinguishable:

- **Low-level classes** implement basic operations (working with a disk, transferring data over a network, connecting to a database).
- **High-level classes** contain complex business logic that directs low-level classes.

Designing low-level classes first (common when prototyping a new system) tends to make business-logic classes depend on primitive low-level ones. DIP reverses this direction:

1. Describe **interfaces for low-level operations** that high-level classes rely on, preferably in **business terms** — e.g. business logic should call `openReport(file)` rather than `openFile(x)`, `readBytes(n)`, `closeFile(x)`. These interfaces count as high-level.
2. Make **high-level classes depend on those interfaces** instead of concrete low-level classes — a much softer dependency.
3. Once **low-level classes implement these interfaces**, they become dependent on the business-logic level, reversing the original dependency.

DIP often goes along with the open/closed principle: you can extend low-level classes for use with different business-logic classes without breaking existing ones.

**Example**: a high-level budget-reporting class uses a low-level database class directly, so a change in the database class (e.g. a new server version) may affect the high-level class that shouldn't care about storage details. **Fix**: create a high-level interface describing read/write operations and make the reporting class use it; then change or extend the low-level class to implement that interface. As a result, the original dependency is inverted — low-level classes now depend on high-level abstractions.
