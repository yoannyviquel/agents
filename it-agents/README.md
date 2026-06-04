# it-agents

Plugin Claude Code embarquant des **agents de développement spécialisés** sous forme de skills.

## Skills inclus

| Skill | Rôle |
|-------|------|
| `dotnet-developer` | Spécialiste implémentation .NET — user stories, code testé/propre, revue, refactoring |
| `react-developer` | Spécialiste implémentation React — user stories, code testé/propre, revue, refactoring |

Chaque skill déclenche sur les mots-clés : `implement story`, `dev story`, `code`, `implement`, `build feature`, `fix bug`, `write tests`, `code review`, `refactor`.

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
    └── react-developer/
```
