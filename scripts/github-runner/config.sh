
#!/bin/bash
# Script de configuration d'un GitHub Actions Runner
# Usage: ./config.sh <REPO_URL> <PAT> <RUNNER_NAME>

set -e

# Charger la config globale
source "$(cd "$(dirname "$0")/../../" && pwd)/config.env"

# Récupérer les paramètres
if [ "$#" -eq 3 ]; then
  REPO_URL="$1"
  RUNNER_TOKEN="$2"
  RUNNER_NAME="$3"
else
  read -p "Entrez l'URL du repo ou de l'organisation (ex: https://github.com/owner/repo): " REPO_URL
  read -p "Entrez le token d'enregistrement du runner OU le token personnel GitHub (PAT, scope repo): " RUNNER_TOKEN
  read -p "Entrez le nom du runner: " RUNNER_NAME
fi

# Si le token ressemble à un PAT, générer le registration token via l'API
if [[ "$RUNNER_TOKEN" == ghp_* || "$RUNNER_TOKEN" == github_pat_* ]]; then
  OWNER=$(echo "$REPO_URL" | awk -F/ '{print $(NF-1)}')
  REPO=$(echo "$REPO_URL" | awk -F/ '{print $NF}' | sed 's/.git$//')
  API_URL="https://api.github.com/repos/$OWNER/$REPO/actions/runners/registration-token"
  echo "Obtention du registration token via l'API GitHub..."
  REG_TOKEN=$(curl -s -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $RUNNER_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "$API_URL" | grep '"token"' | cut -d '"' -f4)
  if [ -z "$REG_TOKEN" ]; then
    echo "Échec de récupération du registration token. Vérifie le PAT et les droits admin sur le repo."
    exit 1
  fi
  RUNNER_TOKEN="$REG_TOKEN"
fi
# Se placer dans le dossier du runner
cd "$EXTERNAL_GITHUB_RUNNER_DIR"

# Configurer le runner
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --name "$RUNNER_NAME" --unattended

bash "$SCRIPTS_DIR/github-runner/apply-cron.sh"