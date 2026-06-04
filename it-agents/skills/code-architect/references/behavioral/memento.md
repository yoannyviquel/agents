# Memento
> *Lets you save and restore the previous state of an object without revealing the details of its implementation.*

**Category:** Behavioral
**Also known as:** Snapshot

## Intent
Capture and externalize an object's internal state — without breaking encapsulation — so the object can be restored to that state later (e.g. for undo or transaction rollback).

## Problem
A text editor wants undo. The direct approach records every object's state before each operation. But producing a snapshot requires reading all fields, and most objects hide significant data in private fields. Making everything public solves the immediate problem but couples other classes to every field and makes refactoring fragile. The snapshot container would also need public fields, exposing all the editor's state. Dead end: expose internals (fragile) or restrict access (can't snapshot).

## Solution
All these problems stem from broken encapsulation — objects invading others' private space. Memento delegates snapshot creation to the state's owner, the **originator**, which has full access to its own state. The snapshot is stored in a special **memento** object whose contents are inaccessible to everyone except its producer; other objects use a limited interface (metadata only — creation time, operation name — not the state). This restrictive policy lets mementos be stored in **caretakers** that can't tamper with the state, while the originator retains full access to restore itself. For the editor, a history class (caretaker) keeps a stack of mementos; on undo it passes the latest memento back to the editor to roll back.

## Structure
**Nested-class implementation** (C++, C#, Java):
1. **Originator** — can produce snapshots of its own state and restore from them.
2. **Memento** — a value object snapshot of the originator's state; commonly immutable, data passed once via constructor.
3. **Caretaker** — knows when/why to capture state and when to restore it; keeps a stack of mementos.
4. The memento is nested inside the originator, so the originator can access its private members while the caretaker has only limited access (store but not tamper).

**Intermediate-interface implementation** (no nested classes, e.g. PHP): caretakers access the memento only via an explicit interface exposing metadata; originators access it directly (downside: memento members must be public).

**Stricter-encapsulation implementation**: multiple originator/memento types; caretakers can't change state; the restoration method lives in the memento, which links to its originator (originator passes itself + state to the memento's constructor).

## Pseudocode (editor + command)
`Editor` (originator) holds `text`, `curX`, `curY`, `selectionWidth`, with setters and `createSnapshot()` returning an immutable `Snapshot`. `Snapshot` (memento) stores the editor reference plus the state and exposes `restore()` which writes the values back via the editor's setters — no public getters/setters, so no object can alter it. `Command` acts as caretaker: `makeBackup()` calls `editor.createSnapshot()`, `undo()` calls `backup.restore()`. Because mementos link to specific editors, the app can support several editor windows with a centralized undo stack.

## Applicability
- Use to **produce snapshots** of an object's state to restore a previous state later — full copies including private fields, stored separately. Indispensable for undo *and* for transactions (rollback on error).
- Use when **direct access to fields/getters/setters violates encapsulation** — Memento makes the object responsible for its own snapshot, keeping its data safe.

## How to Implement
1. Determine the originator class (one central object or many small ones?).
2. Create the memento class with fields mirroring the originator's.
3. Make the memento immutable (data via constructor only, no setters).
4. Nest the memento in the originator if the language supports it; otherwise extract a metadata-only interface other objects use.
5. Add a snapshot-producing method to the originator (returns the interface type if extracted; works with the concrete memento internally).
6. Add a restore method to the originator accepting a memento (typecast to the concrete class for full access).
7. The caretaker (command, history, etc.) decides when to request, store, and restore mementos.
8. Optionally move the caretaker↔originator link and the restoration method into the memento (only sensible if nested or if the originator provides setters).

## Pros and Cons
- ✓ Produce snapshots without violating encapsulation.
- ✓ Simplify the originator by letting the caretaker maintain its state history.
- ✗ The app may consume lots of RAM if clients create mementos too often.
- ✗ Caretakers must track the originator's life cycle to destroy obsolete mementos.
- ✗ Dynamic languages (PHP, Python, JavaScript) can't guarantee the memento's state stays untouched.

## Relations with Other Patterns
- Use **Command** and Memento together for undo: commands perform operations, mementos save state before execution.
- Use **Memento** with **Iterator** to capture and roll back the current iteration state.
- **Prototype** can be a simpler alternative to Memento for straightforward objects without external-resource links.

## Code Examples
- [C#](../code-examples/csharp/Memento.cs)
- [Java](../code-examples/java/Memento.java)
- [TypeScript](../code-examples/typescript/Memento.ts)
- [C++](../code-examples/cpp/Memento.cpp)
- [Swift](../code-examples/swift/Memento.swift)
- [PHP](../code-examples/php/Memento.php)
- [Python](../code-examples/python/memento.py)
- [Go](../code-examples/go/memento.go)
- [Ruby](../code-examples/ruby/memento.rb)
- [Rust](../code-examples/rust/memento.rs)
