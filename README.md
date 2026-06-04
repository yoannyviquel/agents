# yoannyviquel — Marketplace Claude Code

Marketplace de plugins Claude Code permettant d'**importer des agents de développement spécialisés**.

## Ajouter la marketplace

```
/plugin marketplace add yoannyviquel/agents
```

## Plugins disponibles

| Plugin | Description |
|--------|-------------|
| [`it-agents`](./it-agents) | Agents/skills de dev spécialisés : `dotnet-developer`, `react-developer` |

## Installer un plugin

```
/plugin install it-agents@yoannyviquel
```

## Structure du dépôt

```
.
├── .claude-plugin/marketplace.json   # manifeste de la marketplace
└── it-agents/                        # plugin
    ├── .claude-plugin/plugin.json
    ├── package.json
    └── skills/
        ├── dotnet-developer/
        └── react-developer/
```
