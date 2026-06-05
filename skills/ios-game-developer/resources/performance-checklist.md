# Performance Checklist — iOS Games

Run before claiming a story done. Profile on a **real device**, not just the simulator.

## Frame budget
- [ ] Target frame rate chosen for *sustained* play (60 fps, or 120/48/40 on ProMotion)
- [ ] Each frame renders within budget (~16 ms @60, ~8 ms @120)
- [ ] All motion/timing scaled by `deltaTime` (identical behavior across rates)
- [ ] Frame rate verified in Instruments (Game Performance / Metal System Trace)

## CPU
- [ ] No heavy work on the render thread (loading, pathfinding, AI amortized/off-thread)
- [ ] Time Profiler shows no single hot function dominating the frame
- [ ] AI / physics scaled or capped at peak entity counts

## Memory & allocation
- [ ] High-churn objects (bullets, particles, enemies) pooled — no per-frame alloc
- [ ] Allocations instrument: no growth spikes during steady play
- [ ] Leaks instrument: clean (watch closures/actions retaining the scene)
- [ ] Memory-warning handler purges caches / off-screen assets

## GPU & assets
- [ ] Sprites grouped into texture atlases; draw calls bounded
- [ ] Compressed textures (ASTC preferred) at lowest acceptable resolution
- [ ] No per-frame texture loads or shader recompiles
- [ ] SceneKit: LOD + frustum culling; triangle counts reasonable

## Battery & thermal
- [ ] `ProcessInfo.thermalState` observed; quality degrades before OS throttles
- [ ] Idle/paused state stops unnecessary work (timers, audio, updates)
- [ ] Network use batched, not per-frame

## Lifecycle
- [ ] Pause via `scene.isPaused` freezes update + actions cleanly
- [ ] Backgrounding persists progress and pauses
- [ ] `lastUpdate` reset on resume (no delta spike)
- [ ] Audio session interruptions handled and resumed
