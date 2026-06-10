# Chain of Responsibility
> *Lets you pass requests along a chain of handlers. Upon receiving a request, each handler decides either to process the request or to pass it to the next handler in the chain.*

**Category:** Behavioral
**Also known as:** CoR, Chain of Command

## Intent
Decouple a request's sender from its receivers by giving more than one object a chance to handle the request: link handlers into a chain and pass the request along it until one handles it (or it reaches the end).

## Problem
An online ordering system needs sequential checks before handling a request: authentication, then (added over time) request sanitization, brute-force IP filtering, and cached-result short-circuiting. As checks pile up, the code grows bloated; changing one check affects others, and reusing a subset of checks for other components forces code duplication. The system becomes hard to comprehend and maintain.

## Solution
Transform each check into a stand-alone **handler** object with a single handling method that receives the request as an argument. Link handlers into a chain; each holds a reference to the next and, besides processing, passes the request along until all have had a chance — or a handler stops it.

A more canonical variant: on receiving a request a handler decides *whether it can* process it; if so, it stops the chain (only one handler, or none, processes the request). This is common with GUI event stacks — a click event propagates from a button up through its containers to the main window, processed by the first capable element (a chain extracted from an object tree). All handlers must share the same interface; each only knows the next one has a handling method, so you compose chains at runtime without coupling to concrete classes.

## Real-World Analogy
A tech-support call: first an autoresponder offers canned solutions, then a live operator quotes the manual, and finally — if unresolved — an engineer gives the real fix. Your request passes along operators until one can handle it.

## Structure
1. **Handler** — interface common to all handlers, usually one method for handling requests (sometimes a setter for the next handler).
2. **Base Handler** — optional class holding boilerplate: a field for the next handler, chain-building via constructor/setter, and default behavior (forward to the next handler if it exists).
3. **Concrete Handlers** — the actual processing code; each decides whether to process the request and whether to pass it along. Usually self-contained and immutable (data via constructor).
4. **Client** — composes chains once or dynamically; a request can be sent to *any* handler in the chain, not only the first.

## Pseudocode (contextual GUI help)
GUI built with **Composite**: `Component` (with `tooltipText` and a `container` reference) implements `showHelp()` — show tooltip if set, else forward to the container. `Container extends Component` holds children and links each child's `container` to itself. `Button` uses the default; `Panel` (modal help text) and `Dialog` (wiki URL) override `showHelp()` and fall back to `super.showHelp()`. On F1, the app finds the component under the cursor and calls `showHelp()`, which bubbles up the container chain until something can display help.

## Applicability
- Use when your program must process **different kinds of requests in various ways**, but the exact types/sequences are unknown beforehand — link handlers and let each get a chance.
- Use when it's essential to **execute handlers in a particular order** — arrange the chain accordingly.
- Use when the set of handlers and their order should **change at runtime** — add setters to insert/remove/reorder handlers.

## How to Implement
1. Declare the handler interface and the handling-method signature (the most flexible approach passes the request as an object).
2. Optionally create an abstract base handler with the next-handler field and default forwarding behavior (add a setter if chains change at runtime).
3. Create concrete handler subclasses; each decides whether to process and whether to forward.
4. The client assembles chains itself or receives pre-built ones (use factory classes for configuration-based chains).
5. The client may trigger any handler; the request travels until a handler stops it or the chain ends.
6. Be ready for: single-link chains, requests not reaching the end, and requests reaching the end unhandled.

## Pros and Cons
- ✓ Control the order of request handling.
- ✓ Single Responsibility Principle: decouple classes that invoke operations from those that perform them.
- ✓ Open/Closed Principle: introduce new handlers without breaking client code.
- ✗ Some requests may end up unhandled.

## Relations with Other Patterns
- **CoR, Command, Mediator, Observer** all address connecting senders and receivers: CoR passes a request along a dynamic chain until one handles it; **Command** sets unidirectional sender→receiver connections; **Mediator** removes direct connections (communicate via a mediator); **Observer** lets receivers subscribe/unsubscribe dynamically.
- Often used with **Composite**: a leaf's request can travel up through parents to the root.
- CoR handlers can be implemented as **Commands** (many operations over one context), or the request itself can be a Command (same operation across contexts in a chain).
- CoR and **Decorator** share recursive-composition structure, but CoR handlers act independently and may stop the request, while decorators extend behavior without breaking the request flow.

## Code Examples
- [C#](../code-examples/csharp/ChainOfResponsibility.cs)
- [Java](../code-examples/java/ChainOfResponsibility.java)
- [TypeScript](../code-examples/typescript/ChainOfResponsibility.ts)
- [C++](../code-examples/cpp/ChainOfResponsibility.cpp)
- [Swift](../code-examples/swift/ChainOfResponsibility.swift)
- [PHP](../code-examples/php/ChainOfResponsibility.php)
- [Python](../code-examples/python/chain_of_responsibility.py)
- [Go](../code-examples/go/chain_of_responsibility.go)
- [Ruby](../code-examples/ruby/chain_of_responsibility.rb)
- [Rust](../code-examples/rust/chain_of_responsibility.rs)
