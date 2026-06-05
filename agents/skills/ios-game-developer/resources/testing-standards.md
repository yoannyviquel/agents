# Testing Standards — Swift Games

How to test games when the render layer resists unit testing: push logic out of the render layer and test it hard.

## Testing pyramid (game-adapted)

```
        /\        UI tests (Few) — XCUITest, critical menus/flows
       /  \
      /____\      Smoke/integration (Some) — scene setup, transitions, IAP
     /      \
    /________\    Unit tests (Many) — game logic, components, math
```

- ~70% unit (framework-free logic, components, math)
- ~20% smoke/integration (scene wiring, StoreKit flows)
- ~10% UI (menus, store screen, settings)

## What makes game code testable

1. **Framework-free logic.** Domain types must not import SpriteKit/SceneKit/UIKit. If a unit test needs a renderer, the layering is wrong.
2. **Deterministic time.** Feed fixed delta steps into `update`/`tick`; never read wall-clock in logic.
3. **Seeded randomness.** Inject `GKRandomSource` (e.g. `GKMersenneTwisterRandomSource(seed:)`) so spawns/drops are reproducible.
4. **Injected dependencies.** Pass collaborators (random source, clock, services) in — don't reach for singletons.

## Unit tests

```swift
import XCTest

final class WaveSchedulerTests: XCTestCase {
    func test_firstWave_spawnsAfterInitialDelay() {
        var scheduler = WaveScheduler(initialDelay: 2.0, interval: 5.0)
        XCTAssertEqual(scheduler.advance(by: 1.0), 0)   // not yet
        XCTAssertEqual(scheduler.advance(by: 1.0), 1)   // delay reached → wave 1
    }

    func test_seededRandom_isReproducible() {
        let rng = GKMersenneTwisterRandomSource(seed: 42)
        let a = LootTable.roll(using: rng)
        let rng2 = GKMersenneTwisterRandomSource(seed: 42)
        let b = LootTable.roll(using: rng2)
        XCTAssertEqual(a, b)
    }
}
```

## Smoke / integration tests

- Scene loads without crashing; expected child nodes/entities exist.
- Scene transitions (menu → game → game over) wire up and tear down.
- Physics contact callbacks fire for known collisions.

## StoreKit testing

- Use a `.storekit` config + `SKTestSession` to test purchase, restore, and entitlement checks fully offline.
- Simulate errors: product unavailable, user cancels, network failure.
- Verify content is delivered only after `VerificationResult` is verified and the transaction is finished.

## Coverage targets

- Game logic / components: **80%+** (critical rules 90%+)
- Math / utilities: 90%+
- Scene/render: smoke coverage of key paths only
- New code shouldn't lower overall coverage

## Don't test

- Framework internals (SpriteKit physics solver, etc.)
- Trivial node configuration
- Generated code / assets

## Best practices

- One behavior per test; descriptive names `test_<unit>_<expected>_when<condition>`
- AAA structure (Arrange / Act / Assert)
- Independent tests, no shared mutable state
- Cover edge cases: zero/large delta, empty pools, boundary health, pause mid-action
