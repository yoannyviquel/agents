# Singleton
> *Lets you ensure that a class has only one instance, while providing a global access point to this instance.*

**Category:** Creational

## Intent
Guarantee a class has a single shared instance and give the whole program a controlled global access point to it.

## Problem
Singleton solves two problems at once (which itself violates the Single Responsibility Principle):
1. **Ensure a single instance.** Usually to control access to a shared resource (a database, a file). Re-requesting the object returns the already-created one. A regular constructor can't do this — by design it always returns a new object.
2. **Provide a global access point** to that instance. Like a global variable, it's accessible everywhere, but unlike a raw global it protects the instance from being overwritten by other code.

## Solution
All implementations share two steps:
- Make the default constructor **private** to stop other objects from using `new` on the class.
- Create a **static creation method** that acts as a constructor: it calls the private constructor, caches the instance in a static field, and returns that cached object on every subsequent call.

## Real-World Analogy
A government: a country can have only one official government. Regardless of who forms it, "The Government of X" is a single global access point to the group in charge.

## Structure
1. The **Singleton** class declares the static `getInstance` method returning the same instance every time. The constructor is hidden from clients; `getInstance` is the only way to obtain the object.

## Pseudocode (database connection)
A `Database` class has a private static `instance` field and a private constructor (doing the actual connection). Public static `getInstance()` lazily creates the instance on first call and returns the cached one afterward; to be thread-safe it acquires a lock and double-checks `instance == null` inside the lock. A `query(sql)` method holds business logic (a good place for throttling/caching). Two `getInstance()` calls return the same object.

## Applicability
- Use when a class should have **just a single instance** available to all clients (e.g. one shared database object). The pattern disables all other creation means except the special creation method.
- Use when you need **stricter control over global variables** — it guarantees one instance; only the Singleton class itself can replace the cached instance. (You can relax the limit to N instances by editing only `getInstance`.)

## How to Implement
1. Add a private static field to hold the singleton instance.
2. Declare a public static creation method to get the instance.
3. Implement lazy initialization inside it: create on first call, store, and always return that instance afterward.
4. Make the constructor private (only the static method can call it).
5. Replace all direct constructor calls in client code with calls to the static creation method.

## Pros and Cons
- ✓ You can be sure a class has only a single instance.
- ✓ You gain a global access point to that instance.
- ✓ The singleton object is initialized only when first requested.
- ✗ Violates the Single Responsibility Principle (solves two problems at once).
- ✗ Can mask bad design (components knowing too much about each other).
- ✗ Requires special treatment in multithreaded environments so multiple threads don't create it several times.
- ✗ Hard to unit-test client code: test frameworks often rely on inheritance/mocks, but the constructor is private and static methods can't be overridden in most languages.

## Relations with Other Patterns
- A **Facade** class can often be turned into a Singleton (one facade object usually suffices).
- **Flyweight** resembles Singleton if all shared state is reduced to one object, but: there must be only one Singleton, whereas a Flyweight class can have many instances with different intrinsic states; and a Singleton can be mutable, while Flyweights are immutable.
- **Abstract Factories**, **Builders**, and **Prototypes** can all be implemented as Singletons.

## Code Examples
- [C#](../code-examples/csharp/Singleton.cs)
- [Java](../code-examples/java/Singleton.java)
- [TypeScript](../code-examples/typescript/Singleton.ts)
- [C++](../code-examples/cpp/Singleton.cpp)
- [Swift](../code-examples/swift/Singleton.swift)
- [PHP](../code-examples/php/Singleton.php)
- [Python](../code-examples/python/singleton.py)
- [Go](../code-examples/go/singleton.go)
- [Ruby](../code-examples/ruby/singleton.rb)
- [Rust](../code-examples/rust/singleton.rs)
