# RaveOnAutomation

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