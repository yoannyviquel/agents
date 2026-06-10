# Iterator
> *Lets you traverse elements of a collection without exposing its underlying representation (list, stack, tree, etc.).*

**Category:** Behavioral

## Intent
Extract a collection's traversal behavior into a separate iterator object, so clients can step through elements without knowing the collection's internal structure, and multiple traversal algorithms can coexist.

## Problem
A collection is a container for a group of objects, stored as lists, stacks, trees, graphs, etc. It must offer a way to access elements without re-visiting them. Looping is easy for a list, but a tree may need depth-first today, breadth-first tomorrow, random access next week. Adding more traversal algorithms blurs the collection's primary responsibility (efficient storage), and app-specific algorithms don't belong in a generic collection. Meanwhile, client code that doesn't care how elements are stored is still forced to couple to specific collection classes because each exposes a different access method.

## Solution
Extract the traversal behavior into an **iterator** object that implements the algorithm and encapsulates traversal details (current position, elements remaining). Several iterators can traverse the same collection independently. Iterators expose a primary method to fetch elements; the client calls it until nothing is returned. All iterators implement the same interface, so client code works with any collection/traversal as long as a proper iterator exists — add a new traversal by creating a new iterator class without changing the collection or client.

## Real-World Analogy
Visiting Rome: wandering from memory, a smartphone navigation app, or a hired local guide are all *iterators* over the city's vast collection of attractions, each offering a different traversal.

## Structure
1. **Iterator** — interface declaring traversal operations: fetch next element, get current position, restart, etc.
2. **Concrete Iterators** — implement specific traversal algorithms and track progress themselves (enabling independent parallel traversals).
3. **Collection** — interface declaring one or more methods returning iterators (return type is the iterator interface, so collections can return various iterators).
4. **Concrete Collections** — return new concrete iterator instances on request (the rest of the collection's code lives here too).
5. **Client** — works with both collections and iterators via their interfaces; usually obtains iterators from collections, but can create its own special iterator.

## Pseudocode (social graph)
`SocialNetwork` declares `createFriendsIterator(profileId)` and `createCoworkersIterator(profileId)` returning `ProfileIterator`. `Facebook` implements it, returning `FacebookIterator` instances. `ProfileIterator` declares `getNext(): Profile` and `hasMore(): bool`. `FacebookIterator` holds a reference to the collection, `profileId`, `type`, `currentPosition`, and a lazily-initialized `cache` (via a social-graph request). `SocialSpammer.send(iterator, message)` loops with `hasMore()`/`getNext()` — receiving an iterator instead of the whole collection hides the collection and lets you swap traversal at runtime. `Application` configures the network (Facebook/LinkedIn) and passes iterators to the spammer.

## Applicability
- Use when your collection has a **complex data structure** you want to hide from clients (convenience or security) — the iterator exposes simple access methods and protects the collection from careless/malicious direct use.
- Use to **reduce duplication of traversal code** — move bulky iteration algorithms out of business logic into dedicated iterators.
- Use when you want code to **traverse different (or unknown-beforehand) data structures** — generic collection/iterator interfaces keep client code working across implementations.

## How to Implement
1. Declare the iterator interface (at minimum a next-element method; optionally previous, current position, end-check).
2. Declare the collection interface with an iterator-fetching method whose return type is the iterator interface (add more for distinct iterator groups).
3. Implement concrete iterators for each traversable collection; link an iterator to a single collection instance (usually via constructor).
4. Implement the collection interface in your collections; the collection passes itself to the iterator's constructor.
5. Replace collection-traversal code in clients with iterator use; fetch a fresh iterator each time.

## Pros and Cons
- ✓ Single Responsibility Principle: extract bulky traversal algorithms into separate classes.
- ✓ Open/Closed Principle: add new collections/iterators without breaking existing code.
- ✓ Iterate the same collection in parallel (each iterator has its own state).
- ✓ Delay an iteration and continue it later.
- ✗ Overkill for apps that only use simple collections.
- ✗ Using an iterator may be less efficient than going through specialized collections directly.

## Relations with Other Patterns
- Use **Iterators** to traverse **Composite** trees.
- Use **Factory Method** with Iterator so collection subclasses return compatible iterator types.
- Use **Memento** with Iterator to capture the current iteration state and roll it back.
- Use **Visitor** with Iterator to traverse a complex structure and run an operation over elements of different classes.

## Code Examples
- [C#](../code-examples/csharp/Iterator.cs)
- [Java](../code-examples/java/Iterator.java)
- [TypeScript](../code-examples/typescript/Iterator.ts)
- [C++](../code-examples/cpp/Iterator.cpp)
- [Swift](../code-examples/swift/Iterator.swift)
- [PHP](../code-examples/php/Iterator.php)
- [Python](../code-examples/python/iterator.py)
- [Go](../code-examples/go/iterator.go)
- [Ruby](../code-examples/ruby/iterator.rb)
- [Rust](../code-examples/rust/iterator.rs)
