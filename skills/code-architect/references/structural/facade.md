# Facade
> *Provides a simplified interface to a library, a framework, or any other complex set of classes.*

**Category:** Structural

## Intent
Offer a single, simple entry point to a complex subsystem, exposing only the features clients actually need and shielding them from the subsystem's internals.

## Problem
Making your code work with a sophisticated library/framework usually means initializing many objects, tracking dependencies, and calling methods in the right order. Your business logic becomes tightly coupled to the implementation details of 3rd-party classes — hard to comprehend and maintain.

## Solution
A facade is a class providing a simple interface to a complex subsystem with many moving parts. It may offer limited functionality compared to using the subsystem directly, but includes only what clients care about. Example: an app uploading short cat videos to social media could use a professional video-conversion library but really only needs `encode(filename, format)` — that single-method class connected to the library is your first facade.

## Real-World Analogy
Placing a phone order: the operator is your facade to all the shop's services and departments, giving you a simple voice interface to ordering, payment, and delivery.

## Structure
1. **Facade** — provides convenient access to a part of the subsystem's functionality; knows where to direct requests and how to operate the moving parts.
2. **Additional Facade** — optional; prevents polluting one facade with unrelated features. Can be used by clients and by other facades.
3. **Complex Subsystem** — dozens of objects; making them do something meaningful requires deep knowledge of init order and data formats. Subsystem classes are unaware of the facade and work with each other directly.
4. **Client** — uses the facade instead of calling subsystem objects directly.

## Pseudocode (video conversion)
A complex 3rd-party framework has `VideoFile`, `OggCompressionCodec`, `MPEG4CompressionCodec`, `CodecFactory`, `BitrateReader`, `AudioMixer`, etc. A `VideoConverter` facade exposes one `convert(filename, format): File` method that orchestrates extracting the source codec, choosing the destination codec, reading/converting bitrate, and fixing audio. `Application` depends only on `VideoConverter`; switching frameworks means rewriting just the facade.

## Applicability
- Use when you need a **limited but straightforward interface** to a complex subsystem — a shortcut to the most-used features that fit most client requirements.
- Use to **structure a subsystem into layers** — create a facade as the entry point to each layer and have layers communicate only through facades (reduces coupling; resembles **Mediator**).

## How to Implement
1. Check whether you can provide a simpler interface than the subsystem already does — one that makes client code independent of many subsystem classes.
2. Declare and implement that interface in a new facade class, redirecting client calls to the right subsystem objects; the facade also initializes and manages the subsystem's life cycle unless the client already does.
3. For full benefit, make all client code talk to the subsystem only via the facade, so a subsystem upgrade only requires changing the facade.
4. If the facade grows too big, extract part of its behavior into a refined facade.

## Pros and Cons
- ✓ Isolate your code from a subsystem's complexity.
- ✗ A facade can become a *god object* coupled to all classes of an app.

## Relations with Other Patterns
- **Facade** defines a *new* interface over a whole subsystem; **Adapter** makes an *existing* interface usable and usually wraps one object.
- **Abstract Factory** can replace Facade when you only want to hide how subsystem objects are *created*.
- **Flyweight** makes many small objects; Facade makes one object representing a whole subsystem.
- **Facade** and **Mediator** both organize collaboration among tightly coupled classes, but Facade only simplifies the interface (the subsystem is unaware of it and members talk directly), while Mediator centralizes communication (members know only the mediator).
- A Facade can often become a **Singleton** (one facade object usually suffices).
- **Facade** resembles **Proxy** (both buffer a complex entity), but Proxy has the *same* interface as its service.

## Code Examples
- [C#](../code-examples/csharp/Facade.cs)
- [Java](../code-examples/java/Facade.java)
- [TypeScript](../code-examples/typescript/Facade.ts)
- [C++](../code-examples/cpp/Facade.cpp)
- [Swift](../code-examples/swift/Facade.swift)
- [PHP](../code-examples/php/Facade.php)
- [Python](../code-examples/python/facade.py)
- [Go](../code-examples/go/facade.go)
- [Ruby](../code-examples/ruby/facade.rb)
- [Rust](../code-examples/rust/facade.rs)
