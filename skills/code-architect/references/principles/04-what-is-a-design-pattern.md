# What's a Design Pattern?

Design patterns are typical solutions to commonly occurring problems in software design — like pre-made blueprints you can customize to solve a recurring design problem in your code.

## Patterns vs. Code and Algorithms

You can't just find a pattern and copy it into your program the way you can with off-the-shelf functions or libraries. A pattern is not a specific piece of code but a general concept for solving a particular problem; you follow its details and implement a solution that suits your own program.

Patterns are often confused with algorithms because both describe typical solutions to known problems. But an algorithm always defines a clear set of actions to achieve a goal, while a pattern is a more high-level description of a solution — the code of the same pattern applied to two different programs may differ.

- An **algorithm** is like a cooking recipe: clear steps to achieve a goal.
- A **pattern** is more like a blueprint: you see the result and its features, but the exact order of implementation is up to you.

## What a Pattern Consists Of

Most patterns are described formally so people can reproduce them in many contexts. A pattern description usually includes:

- **Intent** — briefly describes both the problem and the solution.
- **Motivation** — further explains the problem and the solution the pattern makes possible.
- **Structure** of classes — shows each part of the pattern and how they relate.
- **Code example** — in a popular language, making the idea easier to grasp.

Some catalogs add other details such as applicability, implementation steps, and relations with other patterns.

## Classification of Patterns

Patterns differ by complexity, level of detail, and scale of applicability. (Analogy: you can make an intersection safer with simple traffic lights or with an entire multi-level interchange.)

- **Idioms** — the most basic, low-level patterns; usually apply to a single programming language.
- **Architectural patterns** — the most universal and high-level; implementable in virtually any language and used to design the architecture of an entire application.

Patterns are also categorized by **intent / purpose**. This book covers three main groups:

- **Creational patterns** provide object creation mechanisms that increase flexibility and reuse of existing code.
- **Structural patterns** explain how to assemble objects and classes into larger structures while keeping them flexible and efficient.
- **Behavioral patterns** take care of effective communication and the assignment of responsibilities between objects.

## Who Invented Patterns

Patterns aren't obscure, sophisticated concepts — they are typical solutions to common problems in object-oriented design. When a solution repeats across various projects, someone eventually names it and describes it in detail; that's how a pattern gets discovered.

The concept of patterns was first described by **Christopher Alexander** in *A Pattern Language: Towns, Buildings, Construction*, which describes a "language" for designing the urban environment, where the units of the language are patterns (e.g. how high windows should be, how many levels a building should have).

The idea was picked up by four authors — **Erich Gamma, John Vlissides, Ralph Johnson, and Richard Helm** — who in 1994 published *Design Patterns: Elements of Reusable Object-Oriented Software*, applying the concept to programming. The book featured 23 patterns and quickly became a best-seller. Due to its lengthy name, people called it "the book by the gang of four", soon shortened to "the GoF book". Since then, dozens of other patterns have been discovered, and the "pattern approach" spread to many programming fields beyond object-oriented design.

## Why Should I Learn Patterns?

You could work as a programmer for years without knowing a single pattern — many people do, and may even implement some without knowing it. So why learn them?

- Design patterns are a **toolkit** of tried-and-tested solutions to common design problems. Even if you never hit these exact problems, knowing patterns teaches you to solve all sorts of problems using object-oriented design principles.
- Design patterns define a **common language** for communicating with teammates more efficiently. You can say "just use a Singleton for that" and everyone understands the idea — no need to explain what a singleton is if you both know the pattern and its name.
