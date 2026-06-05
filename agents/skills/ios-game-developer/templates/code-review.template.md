# Code Review — iOS Game

**PR / Story:** <id + title>
**Reviewer:** <name>
**Target devices / frame rate:** <e.g. iPhone 12+, 60 fps>

## 1. Correctness & acceptance criteria
- [ ] Meets all acceptance criteria
- [ ] Edge cases handled (zero/large delta, empty pools, boundaries, interruptions)
- [ ] Errors handled explicitly, never swallowed

## 2. Architecture & separation
- [ ] Game logic is framework-free (no SpriteKit/SceneKit/UIKit) and unit-testable
- [ ] Composition over inheritance (GKComponent), reuse over recreation
- [ ] Logic / entity-component / scene / UI layers respected
- [ ] No anonymous god-objects; single responsibility per type

## 3. Game loop & timing
- [ ] Motion/cooldowns scaled by deltaTime (frame-rate independent)
- [ ] Core gameplay driven by update loop (not Timer/asyncAfter)
- [ ] `lastUpdate` reset on resume

## 4. Performance
- [ ] High-churn objects pooled; no per-frame allocations in hot paths
- [ ] Draw calls bounded (atlases/batching); textures compressed
- [ ] No blocking work on render thread
- [ ] Profiled in Instruments — frame target held, no leaks/allocation spikes

## 5. Memory & lifecycle
- [ ] No retain cycles (`[weak self]` in stored closures/actions, weak delegates)
- [ ] Pause/resume, backgrounding, memory warnings, audio interruptions handled

## 6. Tests
- [ ] Unit tests for new logic/components (80%+, deterministic time, seeded RNG)
- [ ] Smoke/integration for scene wiring / transitions
- [ ] StoreKit flows tested (if IAP touched)
- [ ] All tests pass

## 7. Code quality
- [ ] Clear Swift naming (API Design Guidelines)
- [ ] No force-unwraps outside guarded cases
- [ ] Comments explain *why*; non-obvious tuning documented
- [ ] Follows existing project conventions

## Verdict
- [ ] Approve  - [ ] Approve with comments  - [ ] Request changes

**Notes:**
