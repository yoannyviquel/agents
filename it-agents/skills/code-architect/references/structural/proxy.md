# Proxy
> *Lets you provide a substitute or placeholder for another object. A proxy controls access to the original object, allowing you to perform something either before or after the request gets through to the original object.*

**Category:** Structural

## Intent
Stand in for a real service object behind the same interface, so you can insert behavior (lazy init, access control, caching, logging, remoting) before/after delegating to the real object — without changing the service or its clients.

## Problem
You have a massive object consuming lots of resources but only needed occasionally. Lazy initialization (create it only when needed) works, but spreading the deferred-init code across all clients duplicates code. Ideally that code lives in the object's class, but that isn't always possible — e.g. the class is part of a closed 3rd-party library.

## Solution
Create a proxy class with the **same interface** as the service object and pass the proxy to all the original object's clients. On receiving a request, the proxy creates/holds the real service object and delegates the work, optionally running logic before or after. Because it shares the interface, the proxy can replace the real service anywhere a client expects it.

## Real-World Analogy
A credit card is a proxy for a bank account, which is a proxy for cash — all share the "make a payment" interface. The consumer avoids carrying cash; the shop owner receives funds electronically without risk of loss or theft.

## Structure
1. **Service Interface** — the interface the proxy must follow to disguise itself as the service.
2. **Service** — the class with the real business logic.
3. **Proxy** — has a reference to a service object; after its own processing (lazy init, logging, access control, caching, …) it passes the request to the service. Proxies usually manage the full life cycle of their service.
4. **Client** — works with both services and proxies via the same interface, so a proxy can be passed to any code expecting a service.

## Pseudocode (YouTube caching proxy)
`ThirdPartyYouTubeLib` declares `listVideos`, `getVideoInfo`, `downloadVideo`. `ThirdPartyYouTubeClass` implements it but re-downloads on every request. `CachedYouTubeClass` implements the same interface, holds a `service` reference plus caches, and returns cached results unless empty or `needReset`, delegating to the service only for real requests. `YouTubeManager` stays unchanged since it works through the interface; `Application.init()` wires a `CachedYouTubeClass` around a `ThirdPartyYouTubeClass` and passes it to the manager.

## Applicability (popular proxy types)
- **Lazy initialization (virtual proxy)** — defer creating a heavyweight service object until it's really needed.
- **Access control (protection proxy)** — pass the request only if the client's credentials match (e.g. OS-critical objects vs. arbitrary apps).
- **Local execution of a remote service (remote proxy)** — the service lives on a remote server; the proxy handles the network details.
- **Logging requests (logging proxy)** — record each request before passing it on.
- **Caching request results (caching proxy)** — cache recurring requests (request params as cache keys) and manage that cache's life cycle.
- **Smart reference** — track clients of a heavyweight object and dismiss it (freeing resources) once no clients remain; can reuse unmodified objects.

## How to Implement
1. If no service interface exists, create one to make proxy and service interchangeable; if extracting it isn't feasible, make the proxy a subclass of the service to inherit its interface.
2. Create the proxy class with a field for the service reference (proxies usually create and manage the service's whole life cycle; occasionally the client passes the service via constructor).
3. Implement the proxy methods per purpose, delegating to the service after doing their work.
4. Consider a creation method (static method or factory) that decides whether the client gets a proxy or a real service.
5. Consider implementing lazy initialization of the service.

## Pros and Cons
- ✓ Control the service object without clients knowing.
- ✓ Manage the service object's life cycle when clients don't care about it.
- ✓ The proxy works even if the service isn't ready or available.
- ✓ Open/Closed Principle: introduce new proxies without changing the service or clients.
- ✗ Code can become more complicated (many new classes).
- ✗ The service response might get delayed.

## Relations with Other Patterns
- **Adapter** gives a *different* interface; **Proxy** keeps the *same* interface; **Decorator** gives an *enhanced* interface.
- **Facade** resembles Proxy (both buffer a complex entity and init it themselves), but Proxy has the same interface as its service, making them interchangeable.
- **Decorator** and Proxy share structure but differ in intent: a Proxy usually manages its service's life cycle itself, while a Decorator stack is always controlled by the client.

## Code Examples
- [C#](../code-examples/csharp/Proxy.cs)
- [Java](../code-examples/java/Proxy.java)
- [TypeScript](../code-examples/typescript/Proxy.ts)
- [C++](../code-examples/cpp/Proxy.cpp)
- [Swift](../code-examples/swift/Proxy.swift)
- [PHP](../code-examples/php/Proxy.php)
- [Python](../code-examples/python/proxy.py)
- [Go](../code-examples/go/proxy.go)
- [Ruby](../code-examples/ruby/proxy.rb)
- [Rust](../code-examples/rust/proxy.rs)
