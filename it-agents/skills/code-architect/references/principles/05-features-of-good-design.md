# Features of Good Design

Before reaching the patterns themselves, it's worth discussing the goals of designing software architecture — things to aim for (code reuse and extensibility) and things to avoid.

## Code Reuse

Cost and time are two of the most valuable metrics in software development. Less development time means entering the market earlier than competitors; lower costs mean more money for marketing and broader reach.

**Code reuse** is one of the most common ways to reduce development costs: instead of building something from scratch repeatedly, reuse existing code in new projects. The idea looks great on paper, but making existing code work in a new context usually takes extra effort. Tight coupling between components, dependencies on concrete classes instead of interfaces, and hardcoded operations all reduce flexibility and make code harder to reuse.

Using design patterns is one way to increase flexibility and ease reuse — though sometimes at the price of making components more complicated.

### Erich Gamma on Three Levels of Reuse

Erich Gamma, one of the founding fathers of design patterns, describes three levels of reuse:

- **Lowest level — classes**: reusing class libraries, containers, and class "teams" like container/iterator.
- **Middle level — patterns**: design patterns are both smaller and more abstract than frameworks. They describe how a couple of classes can relate to and interact with each other. Patterns let you reuse design ideas and concepts independently of concrete code, in a way that is **less risky** than frameworks.
- **Highest level — frameworks**: frameworks distill your design decisions, identifying the key abstractions for solving a problem, representing them as classes, and defining their relationships (JUnit is a small example, with `Test`, `TestCase`, `TestSuite`). A framework is larger-grained than a single class; you hook into it by subclassing. Frameworks use the "Hollywood principle" — "don't call us, we'll call you": the framework calls your custom behavior when it's your turn. Building a framework is high-risk and a significant investment.

The level of reuse increases as you move from classes to patterns and finally to frameworks.

## Extensibility

Change is the only constant in a programmer's life. Examples:

- You released a video game for Windows, but now people ask for a macOS version.
- You created a GUI framework with square buttons, but months later round buttons become a trend.
- You designed a brilliant e-commerce architecture, but a month later customers ask for a feature to accept phone orders.

There are several reasons this happens:

1. **We understand the problem better once we start solving it.** By the time you finish a first version, you often understand the problem well enough to want to rewrite it from scratch — and you've grown professionally, so your old code now looks like crap.
2. **Something beyond your control changes.** Teams pivot for external reasons — for example, everyone who relied on Flash had to rework or migrate as browsers dropped support.
3. **The goalposts move.** A delighted client now sees eleven "little" changes; these aren't frivolous — your excellent first version showed them that even more is possible.

> Bright side: if someone asks you to change something in your app, it means someone still cares about it.

That's why all seasoned developers try to provide for possible future changes when designing an application's architecture.
