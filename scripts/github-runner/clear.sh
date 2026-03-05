#!/bin/bash
# Script de suppression du GitHub Actions Runner
# Usage: ./clear.sh

set -e
# Charger la config globale
source "$(cd "$(dirname "$0")/../../" && pwd)/config.env"


echo "Suppression du GitHub Actions Runner et des crons associés..."

# Supprime le .runner du dossier externe et les crons associés
rm -f "$EXTERNAL_GITHUB_RUNNER_DIR/.runner"
crontab -l 2>/dev/null | grep -v "# managed-by:.github" | crontab - || true

# fait un remove du runner via la config du runner
cd "$EXTERNAL_GITHUB_RUNNER_DIR"
bash ./config.sh remove

echo "GitHub Actions Runner supprimé avec succès !"