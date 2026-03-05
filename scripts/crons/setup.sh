#!/bin/bash

# Script d'installation des tâches cron
# Usage: ./setup.sh

set -e

CRONS_DIR="$(cd "$(dirname "$0")/../../crons" && pwd)"

echo "Installation des tâches cron depuis $CRONS_DIR..."

# Supprimer les crons existants gérés par ce projet (marqués par un tag)
crontab -l 2>/dev/null | grep -v "# managed-by:.github" | crontab - || true

# Ajouter les nouvelles tâches depuis les fichiers .cron
for cron_file in "$CRONS_DIR"/*.cron; do
  [ -f "$cron_file" ] || continue
  echo "Ajout des crons depuis $(basename "$cron_file")..."
  (crontab -l 2>/dev/null; cat "$cron_file") | crontab -
done

echo "Tâches cron installées avec succès !"
crontab -l
