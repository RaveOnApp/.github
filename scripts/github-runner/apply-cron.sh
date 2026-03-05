
#!/bin/bash
# Script d'exécution du GitHub Actions Runner
# Usage: ./execute.sh

set -e

# Charger la config globale
source "$(cd "$(dirname "$0")/../../" && pwd)/config.env"

# Copier le cron github-runner dans le dossier externe, substituer les placeholders et l'ajouter à la crontab
if [ -n "$CRONS_DIR" ] && [ -n "$EXTERNAL_CRONS_DIR" ] && [ -n "$EXTERNAL_GITHUB_RUNNER_DIR" ]; then
  mkdir -p "$EXTERNAL_CRONS_DIR"
  mkdir -p "$EXTERNAL_GITHUB_RUNNER_DIR/logs"

  RUN_SH_PATH="$EXTERNAL_GITHUB_RUNNER_DIR/run.sh"
  LOG_PATH="$EXETERNAL_LOGS_DIR/github-runner.log"
  mkdir -p "$EXETERNAL_LOGS_DIR"
  touch "$LOG_PATH"

  # Copier et substituer les placeholders avec les chemins absolus
  sed \
    -e "s|{{RUN_SH_PATH}}|$RUN_SH_PATH|g" \
    -e "s|{{LOG_PATH}}|$LOG_PATH|g" \
    "$CRONS_DIR/github-runner.cron" > "$EXTERNAL_CRONS_DIR/github-runner.cron"

  # Ajouter à la crontab en conservant les autres entrées
  crontab "$EXTERNAL_CRONS_DIR/github-runner.cron"
  echo "Cron github-runner installé avec les chemins absolus depuis $EXTERNAL_CRONS_DIR/github-runner.cron."

  # Exécuter immédiatement le cron sans attendre la prochaine minute
  echo "Exécution immédiate du runner..."
  pgrep -f "$RUN_SH_PATH" > /dev/null || nohup bash -c "exec -a github-runner $RUN_SH_PATH" >> "$LOG_PATH" 2>&1 &
  echo "Runner démarré."
fi
