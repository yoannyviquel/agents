# Clean Code Checklist — Swift Games

Quick checklist before marking game code complete.

## Naming & API
- [ ] Names clear at the call site (Swift API Design Guidelines)
- [ ] No abbreviations that hurt readability (`spawnEnemy(at:)`, not `spawn(p:)`)
- [ ] Types named for their role: `…Component`, `…System`, `…Scene`, `…State`

## Structure
- [ ] Game logic is **framework-free** (no SpriteKit/SceneKit/UIKit imports) and unit-testable
- [ ] Composition over inheritance — behavior in `GKComponent`s, not deep node subclasses
- [ ] One component / one concern; reused across entities where possible
- [ ] Functions small, single-responsibility
- [ ] No duplicated logic (DRY) — shared code extracted

## Types & memory
- [ ] `struct`/`enum` for game state/config where appropriate
- [ ] No retain cycles: `[weak self]` in stored closures / actions; `weak` delegates
- [ ] No force-unwraps (`!`) except guarded programmer-error cases
- [ ] High-churn objects pooled, not allocated per frame

## Timing & loop
- [ ] All motion/cooldowns scaled by `deltaTime` (frame-rate independent)
- [ ] Core gameplay driven by the update loop, not `Timer`/`asyncAfter`
- [ ] `lastUpdate` reset on resume to avoid a delta spike

## Concurrency & threads
- [ ] No blocking I/O / heavy compute on the render thread
- [ ] Node mutations happen on the main actor
- [ ] Loading/pathfinding/AI amortized or off-thread

## Errors & lifecycle
- [ ] Errors handled explicitly (`throws`/`Result`), never swallowed
- [ ] Pause/resume, backgrounding, interruptions, memory warnings handled
- [ ] Audio session interruptions handled

## Comments
- [ ] Comments explain *why*, not *what*
- [ ] Non-obvious tuning (thermal, pacing) documented
