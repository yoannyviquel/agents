# Code Examples — Original, Shareable Implementations

Original, self-contained conceptual implementations of the 22 classic GoF design
patterns, in 10 languages. **Authored independently** for the `code-architect`
skill and released under the [MIT License](./LICENSE) — no third-party example
set was copied, adapted, or derived from. The design patterns are public-domain
concepts.

Each file is a single, runnable conceptual demo of one pattern: the pattern's
participants (with generic, role-based names) plus a small client/`main` that
exercises them and prints output. They are meant as reference implementations to
match against the language a target codebase already uses — not as a library.

## Layout (one file per pattern per language)

| Language | Folder | File naming |
|----------|--------|-------------|
| C# | `csharp/` | `PascalCase.cs` |
| Java | `java/` | `PascalCase.java` |
| TypeScript | `typescript/` | `PascalCase.ts` |
| C++ | `cpp/` | `PascalCase.cpp` |
| Swift | `swift/` | `PascalCase.swift` |
| PHP | `php/` | `PascalCase.php` |
| Python | `python/` | `snake_case.py` |
| Go | `go/` | `snake_case.go` |
| Ruby | `ruby/` | `snake_case.rb` |
| Rust | `rust/` | `snake_case.rs` |

See [INDEX.md](./INDEX.md) for the full pattern → language → file map. Each
pattern reference file (e.g. `../creational/factory-method.md`) links to its
example in every language.
