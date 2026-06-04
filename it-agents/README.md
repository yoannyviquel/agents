# it-agents

Plugin Claude Code embarquant des **agents de développement spécialisés** sous forme de skills.

## Skills inclus

| Skill | Rôle |
|-------|------|
| `dotnet-developer` | Spécialiste implémentation .NET — user stories, code testé/propre, revue, refactoring |
| `react-developer` | Spécialiste implémentation React — user stories, code testé/propre, revue, refactoring |
| `code-architect` | Architecte logiciel — conçoit une architecture à base de design patterns (base de connaissances *Dive Into Design Patterns* embarquée : 22 patterns GoF + principes + exemples 10 langages), cartographie l'impact sur 3 niveaux, livre plan d'archi, ADR et plan de dev Claude Code |

Mots-clés des skills *developer* : `implement story`, `dev story`, `code`, `implement`, `build feature`, `fix bug`, `write tests`, `code review`, `refactor`.
Mots-clés de `code-architect` : `design architecture`, `architect this`, `which pattern`, `design pattern`, `architecture plan`, `ADR`.

## Installation

Via la marketplace `yoannyviquel` :

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
            ├── creational/ structural/ behavioral/   # 22 fiches pattern
            └── code-examples/      # exemples 10 langages + INDEX.md
```
