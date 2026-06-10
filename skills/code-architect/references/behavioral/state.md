# State
> *Lets an object alter its behavior when its internal state changes. It appears as if the object changed its class.*

**Category:** Behavioral

## Intent
Represent each state of an object as a separate class implementing a common interface, and have the object delegate state-specific behavior to its current state object — replacing sprawling state conditionals.

## Problem
State is closely related to a **Finite-State Machine**: at any moment a program is in one of a finite number of states, behaves differently in each, and transitions between them per predetermined rules. Example: a `Document` can be `Draft`, `Moderation`, or `Published`; its `publish()` behaves differently in each (Draft → moderation; Moderation → published only if admin; Published → nothing). State machines are usually built with big `if`/`switch` statements selecting behavior by the object's fields. As states and state-dependent behaviors multiply, most methods fill with monstrous conditionals; changing transition logic forces edits across every method — hard to maintain and hard to predict at design time.

## Solution
Create a class for each possible state and extract all state-specific behavior into it. The original object — the **context** — stores a reference to a state object representing its current state and delegates state-related work to it. To transition, replace the active state object with another. This works only if all state classes share an interface and the context works through it.

This resembles **Strategy**, with one key difference: in State the particular states may be aware of each other and initiate transitions, whereas strategies almost never know about each other.

## Real-World Analogy
A smartphone's buttons behave differently by state: unlocked (run functions), locked (show unlock screen), low charge (show charging screen).

## Structure
1. **Context** — stores a reference to a concrete state and delegates state-specific work to it through the state interface; exposes a setter for switching state.
2. **State** — interface declaring the state-specific methods (meaningful for all concrete states).
3. **Concrete States** — implement the state-specific methods (use intermediate abstract classes for common behavior). State objects may hold a backreference to the context, used to fetch context info and initiate transitions.
4. Both context and concrete states can set the context's next state by replacing the linked state object.

## Pseudocode (media player)
`AudioPlayer` (context) holds a `state: State`, starts in `ReadyState`, and exposes UI methods (`clickLock`, `clickPlay`, `clickNext`, `clickPrevious`) that delegate to the active state, plus service methods (`startPlayback`, `stopPlayback`, `nextSong`, …) and `changeState(state)`. Abstract `State` holds a `player` backreference and declares the click methods. `LockedState`, `ReadyState`, `PlayingState` implement them differently and trigger transitions via `player.changeState(new …State(player))` — e.g. in `PlayingState`, `clickPlay()` stops playback and switches to `ReadyState`.

## Applicability
- Use when an object **behaves differently per state**, states are numerous, and state-specific code changes frequently — add/modify states independently.
- Use when a class is **polluted with massive conditionals** that alter behavior by field values — extract conditional branches into state-class methods and clean out temporary fields/helpers.
- Use when there's **duplicate code across similar states** of a condition-based state machine — compose state-class hierarchies and pull common code into abstract base classes.

## How to Implement
1. Decide the context class (existing state-dependent class, or a new one).
2. Declare the state interface, aiming only for methods that may contain state-specific behavior.
3. Create a class per state deriving from the interface; extract state-related code from the context. If it depends on private context members: make them public, expose a public method on the context, or nest state classes in the context (if supported).
4. Add a state-interface reference field and a public setter to the context.
5. Replace the context's state conditionals with calls to the state object's methods.
6. To switch state, instantiate a state class and pass it to the context (done in the context, in states, or in the client).

## Pros and Cons
- ✓ Single Responsibility Principle: organize state-specific code into separate classes.
- ✓ Open/Closed Principle: introduce new states without changing existing states or the context.
- ✓ Simplify the context by eliminating bulky state-machine conditionals.
- ✗ Overkill if a state machine has only a few states or rarely changes.

## Relations with Other Patterns
- **Bridge**, **State**, **Strategy** (and to a degree **Adapter**) share composition-based structures but solve different problems.
- **State can be seen as an extension of Strategy**: both delegate to helper objects, but Strategy makes them independent and mutually unaware, while State lets concrete states know about and transition each other.

## Code Examples
- [C#](../code-examples/csharp/State.cs)
- [Java](../code-examples/java/State.java)
- [TypeScript](../code-examples/typescript/State.ts)
- [C++](../code-examples/cpp/State.cpp)
- [Swift](../code-examples/swift/State.swift)
- [PHP](../code-examples/php/State.php)
- [Python](../code-examples/python/state.py)
- [Go](../code-examples/go/state.go)
- [Ruby](../code-examples/ruby/state.rb)
- [Rust](../code-examples/rust/state.rs)
