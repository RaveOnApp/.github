# RaveOnAutomation

Repo centralisé de génération, déploiement et automatisation des services :
**GitHub Runner**, **API**, **Base de données SQL**, **Crons**.

## Structure du repo

```
.github.git/
├── .github/
│   ├── ISSUE_TEMPLATE/         # Templates d'issues (bug, feature, task)
│   └── workflows/              # GitHub Actions workflows
├── crons/
│   ├── cleanup.cron            # Nettoyage des logs
│   └── db-backup.cron          # Sauvegarde de la base de données
├── scripts/
│   ├── github-runner/
│   │   └── install.sh          # Installation et démarrage du GitHub Actions Runner
│   ├── api/
│   │   └── deploy.sh           # Déploiement de l'API
│   ├── db/
│   │   ├── setup.sh            # Configuration initiale de la base de données
│   │   └── migrate.sh          # Exécution des migrations SQL
│   └── crons/
│       └── setup.sh            # Installation des tâches cron
└── README.md
```

## Services

### GitHub Runner
Installe et configure un GitHub Actions Runner auto-hébergé.
```bash
bash scripts/github-runner/install.sh
```

### API
Déploie l'API sur l'environnement cible.
```bash
bash scripts/api/deploy.sh --env production --tag latest
```

### Base de données SQL
Configure la base et applique les migrations.
```bash
bash scripts/db/setup.sh --env production
bash scripts/db/migrate.sh --env production
```

### Crons
Installe toutes les tâches cron définies dans `crons/*.cron`.
```bash
bash scripts/crons/setup.sh
```

---

A collection of GitHub automation templates and workflows for project management.

## Issue Templates

Three issue templates are available when opening a new issue:

| Template | Label | Purpose |
|---|---|---|
| **Bug Report** | `bug` | Report unexpected behavior or errors |
| **Feature Request** | `enhancement` | Suggest new features or improvements |
| **Task** | `task` | Define a unit of work with acceptance criteria |

## Project Column Automation

The workflow `.github/workflows/project-automation.yml` listens for GitHub Projects (v2) item status changes and automates common actions:

| Status → | Action |
|---|---|
| **In Progress** | Adds the `in-progress` label to the linked issue |
| **Done** | Closes the linked issue as *completed* |

### Setup

1. Create a GitHub Project (v2) for this repository with a **Status** field containing at least `In Progress` and `Done` columns.
2. Add issues to the project board.
3. The workflow triggers automatically whenever a project item's **Status** field is updated.

> **Note:** The workflow requires the default `GITHUB_TOKEN` with `issues: write` and `repository-projects: read` permissions. These are granted automatically on standard repositories.