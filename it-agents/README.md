# it-agents

Claude Code plugin bundling **specialized development agents** as skills.

## Included skills

| Skill | Role |
|-------|------|
| `dotnet-developer` | .NET implementation specialist — user stories, tested/clean code, review, refactoring |
| `react-developer` | React implementation specialist — user stories, tested/clean code, review, refactoring |
| `code-architect` | Software architect — designs an architecture based on design patterns (bundled *Dive Into Design Patterns* knowledge base: 22 GoF patterns + principles + examples in 10 languages), maps impact across 3 levels, delivers an architecture plan, ADRs and a Claude Code dev plan |

*developer* skill keywords: `implement story`, `dev story`, `code`, `implement`, `build feature`, `fix bug`, `write tests`, `code review`, `refactor`.
`code-architect` keywords: `design architecture`, `architect this`, `which pattern`, `design pattern`, `architecture plan`, `ADR`.

## Installation

Via the `yoannyviquel` marketplace:

```
/plugin marketplace add yoannyviquel/agents
/plugin install it-agents@yoannyviquel
```

## Structure

```
it-agents/
├── .claude-plugin/plugin.json
├── package.json
└── skills/
    ├── dotnet-developer/
    ├── react-developer/
    └── code-architect/
        ├── SKILL.md
        └── references/
            ├── patterns-index.md
            ├── principles/        # OOP, design principles, SOLID
            ├── creational/ structural/ behavioral/   # 22 pattern sheets
            └── code-examples/      # examples in 10 languages + INDEX.md
```
