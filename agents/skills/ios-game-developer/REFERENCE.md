# iOS Game Developer Reference Guide

Detailed standards, patterns, and best practices for Swift game implementation on Apple platforms. Sourced from Apple developer documentation (SpriteKit, SceneKit, Metal, GameplayKit, StoreKit) and current iOS game-dev practice.

## Table of Contents

1. [Framework Selection](#framework-selection)
2. [Architecture: Entity-Component & Game Loop](#architecture-entity-component--game-loop)
3. [Clean Swift Standards](#clean-swift-standards)
4. [Performance & Frame Budget](#performance--frame-budget)
5. [App Lifecycle](#app-lifecycle)
6. [Services: StoreKit 2 & Game Center](#services-storekit-2--game-center)
7. [Testing Standards](#testing-standards)
8. [Git Workflow](#git-workflow)

## Framework Selection

Pick the lowest-level framework that meets the need; combine when it pays off.

| Framework | Use for | Notes |
|-----------|---------|-------|
| **SpriteKit** | 2D games, casual to complex | Built-in physics, particles, animation, actions. Use texture atlases + batching; can struggle past thousands of sprites. |
| **SceneKit** | 3D scenes & character models | Keep polygon counts reasonable (LOD), use frustum culling. Optimize for mobile. |
| **Metal** | Custom rendering, max performance | Manage everything manually; profile constantly with Metal System Trace. Reach for it for custom shaders/effects, not whole games unless needed. |
| **GameplayKit** | Structure & AI (any renderer) | Entity-component, state machines (`GKStateMachine`), pathfinding (`GKGraph`), agents/goals/behaviors, rule systems, randomization (`GKRandomSource`). |

**Combined approach** is common and recommended: SceneKit for 3D world, SpriteKit for HUD/menus, Metal for a custom water shader or special effect — each framework for its strength.

**Why Swift-native over a cross-platform engine:** native performance, seamless OS integration, and smaller app size (SpriteKit/SceneKit builds are typically far smaller than equivalent Unity builds). Trade-off: Apple-only.

## Architecture: Entity-Component & Game Loop

### Entity-Component (composition over inheritance)

An **entity** (`GKEntity`) is a container; behavior comes from **components** (`GKComponent`), each handling one limited concern. Components are reusable across entities. Avoid deep `SKNode`/`SCNNode` subclass trees.

```swift
import GameplayKit
import SpriteKit

// One component = one concern. Pure-ish logic, easy to reason about & test.
final class HealthComponent: GKComponent {
    private(set) var current: Int
    let max: Int

    init(max: Int) {
        self.current = max
        self.max = max
        super.init()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var isDead: Bool { current <= 0 }

    func apply(damage: Int) {
        precondition(damage >= 0, "damage must be non-negative")
        current = Swift.max(0, current - damage)
    }
}

final class MovementComponent: GKComponent {
    var velocity: CGVector = .zero

    // Frame-rate independent: scale by deltaTime.
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        node.position.x += velocity.dx * CGFloat(seconds)
        node.position.y += velocity.dy * CGFloat(seconds)
    }
}
```

Drive components from a `GKComponentSystem` per component type, updated once per frame from the scene.

### Game loop

The update/render cycle: the **update** phase advances gameplay state; the **render** phase runs animation/physics and draws. In SpriteKit you hook `update(_:)`:

```swift
final class GameScene: SKScene {
    private let movementSystem = GKComponentSystem(componentClass: MovementComponent.self)
    private var lastUpdate: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        // Compute delta once; pass it everywhere. Never assume a fixed step.
        let delta = lastUpdate == 0 ? 0 : currentTime - lastUpdate
        lastUpdate = currentTime
        movementSystem.update(deltaTime: delta)
    }
}
```

**Rule:** all gameplay timing flows from this delta. No `Timer`/`DispatchQueue.asyncAfter` driving core gameplay — they drift and ignore pause.

## Clean Swift Standards

- **Naming:** follow Swift API Design Guidelines (clarity at call site; `spawnEnemy(at:)` not `spawn(p:)`).
- **Value vs reference:** prefer `struct`/`enum` for game state and config; nodes are inherently reference types.
- **Optionals:** unwrap explicitly; avoid force-unwrap (`!`) outside of programmer-error preconditions.
- **Retain cycles:** capture `[weak self]` in closures stored on long-lived nodes/actions; use `weak` delegates. A strong closure on an `SKAction` retaining the scene is a common leak.
- **Error handling:** `throws` + `Result` for fallible logic; never swallow errors silently.
- **Concurrency:** keep render-thread work minimal; do loading/pathfinding off-thread (`Task`/background queue) and hop back to the main actor to touch nodes.
- **Comments:** explain *why* (e.g. "spawn cadence eased to avoid thermal throttling on A12"), not *what*.

```swift
// Good — frame-rate independent, framework-free logic, testable
struct DashState {
    let cooldown: TimeInterval
    private(set) var remaining: TimeInterval = 0
    private(set) var isInvulnerable = false

    mutating func tick(_ dt: TimeInterval) {
        remaining = max(0, remaining - dt)
        if remaining == 0 { isInvulnerable = false }
    }
    mutating func tryDash(iFrames: TimeInterval) -> Bool {
        guard remaining == 0 else { return false }
        remaining = cooldown
        isInvulnerable = true
        return true
    }
}
```

## Performance & Frame Budget

Each frame must render within its budget: **~16 ms at 60 fps, ~8 ms at 120 fps (ProMotion)**.

**Frame rate:**
- Target a rate the device can *sustain* for a whole session, not a peak. With ProMotion you can also choose 40/48 fps to buy headroom for quality or power.
- Make all motion delta-time scaled so behavior is identical across frame rates.

**Memory & allocation:**
- **Object pooling** for high-churn objects (bullets, particles, enemies): reuse from a pool; per-frame alloc/dealloc causes micro-stutter.
- Profile with Instruments **Allocations** and **Leaks**; watch object counts and memory pressure.
- Respond to memory warnings — purge caches, evict off-screen assets.

**GPU & assets:**
- **Texture atlases** group sprites → fewer draw calls; batch where possible.
- Use compressed texture formats (**ASTC** preferred on modern Apple GPUs; PVRTC legacy) at the lowest acceptable resolution.
- SceneKit: keep triangles reasonable (LOD), frustum-cull off-screen objects.
- Avoid per-frame texture loads or shader recompilation.

**Battery & thermal:**
- Manage CPU/GPU/network use; idle work off when not needed.
- Query/observe `ProcessInfo.processInfo.thermalState`; degrade quality (lower fps/effects) as it rises rather than letting the OS throttle you.

**Profiling tools:** Instruments (Time Profiler, Allocations, Leaks), **Metal System Trace** / **Game Performance** template, Metal Performance HUD, the Metal debugger. Profile on a real device — simulator GPU characteristics differ.

## App Lifecycle

Games must survive interruptions cleanly:

- **Pause/resume:** pausing the scene (`scene.isPaused = true`) freezes the update loop and actions — drive game pause through it, not custom timers.
- **Backgrounding:** on `scenePhase`/`UIApplication` background, pause, persist progress, release nothing the user expects to return to.
- **Interruptions:** phone calls, notifications, audio session interruptions — handle `AVAudioSession` interruption notifications; resume audio correctly.
- **Memory warnings:** free caches and rebuildable assets.
- **Reset `lastUpdate`** after resume so the first delta isn't a huge jump.

## Services: StoreKit 2 & Game Center

**StoreKit 2 (in-app purchase):** async/await `Product` / `Transaction` / `Transaction.currentEntitlements` model. Verify transactions (`VerificationResult`), finish them after delivering content, and handle restore. Build error handling for unavailable products and user cancellation.

**Testing IAP:** use **StoreKit Testing in Xcode** (`.storekit` config) to test fully offline without App Store Connect, simulate errors (product unavailable, user cancels), and automate via `SKTestSession`. Then sandbox, then TestFlight.

**Game Center (GameKit):** authenticate `GKLocalPlayer`, leaderboards, achievements, matchmaking. All prerelease testing runs in the same server environment as released games — no separate sandbox toggle.

**App Store:** games using IAP must use StoreKit for digital goods; declare Game Center capability; respect age-rating and gambling/loot-box disclosure rules.

## Testing Standards

The render layer is hard to unit-test; the logic layer is not — so **keep them separate** and test the logic heavily.

| Layer | Test type | Tool | Target |
|-------|-----------|------|--------|
| Game logic / components (framework-free) | Unit, deterministic | XCTest / Swift Testing | 80%+ |
| Scene setup / transitions | Smoke / integration | XCTest | key paths |
| IAP flows | StoreKit testing | StoreKit Testing in Xcode | all paths |
| UI / menus | UI tests | XCUITest | critical flows |

**Deterministic time:** feed fixed delta steps into update logic; never rely on wall-clock. Inject `GKRandomSource` (seeded `GKMersenneTwisterRandomSource`) so randomness is reproducible in tests.

```swift
import XCTest

final class DashStateTests: XCTestCase {
    func test_dash_setsCooldownAndInvulnerability() {
        var dash = DashState(cooldown: 1.0)
        XCTAssertTrue(dash.tryDash(iFrames: 0.3))
        XCTAssertTrue(dash.isInvulnerable)
        XCTAssertFalse(dash.tryDash(iFrames: 0.3), "cannot dash while on cooldown")
    }

    func test_dash_recoversAfterCooldown() {
        var dash = DashState(cooldown: 1.0)
        _ = dash.tryDash(iFrames: 0.3)
        dash.tick(1.0)                       // deterministic time step
        XCTAssertFalse(dash.isInvulnerable)
        XCTAssertTrue(dash.tryDash(iFrames: 0.3))
    }
}
```

**Naming:** `test_<unitOfWork>_<expected>_when<condition>()`. AAA structure (Arrange/Act/Assert). One behavior per test. Keep tests independent.

**Don't test:** framework internals, trivial node setup, generated code.

## Git Workflow

Conventional Commits:

```
feat(combat): add player dash with i-frames
fix(spawn): reset lastUpdate on resume to avoid delta spike
perf(render): pool enemy nodes to remove per-wave allocations
test(combat): add dash cooldown timing tests
```

**Types:** `feat`, `fix`, `refactor`, `test`, `perf`, `docs`, `chore`.
**Branches:** `feature/STORY-ID-desc`, `fix/desc`, `hotfix/critical`.
**Frequency:** commit per logical unit; push regularly.

## Summary

- Pick the right framework; combine for strengths.
- Separate framework-free logic from the render layer — it's what makes the game testable.
- Composition (entity-component) over inheritance.
- One game loop owns time; everything is delta-time scaled.
- Pool churny objects; atlas/batch sprites; profile in Instruments.
- Hold a *sustainable* frame rate; watch thermal/battery.
- Handle lifecycle (pause/resume/background/memory) explicitly.
- Test logic to 80%+ with deterministic time and seeded randomness.
