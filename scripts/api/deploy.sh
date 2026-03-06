#!/bin/bash

# Script de déploiement de l'API
# Usage: ./deploy.sh <REPO_URL> <PAT> <ENV>
#   REPO_URL : URL du repo GitHub (ex: https://github.com/owner/repo)
#   PAT      : Token personnel GitHub (scope repo)
#   ENV      : Branche à déployer (ex: production, staging, main)

set -e

# Charger la config globale
source "$(cd "$(dirname "$0")/../../" && pwd)/config.env"

# Récupérer les paramètres
if [ "$#" -eq 3 ]; then
  REPO_URL="$1"
  PAT="$2"
  ENV="$3"
else
  read -p "Entrez l'URL du repo (ex: https://github.com/owner/repo): " REPO_URL
  read -p "Entrez le token personnel GitHub (PAT, scope repo): " PAT
  read -p "Entrez l'environnement / branche à déployer (ex: production): " ENV
fi

# Extraire le nom du repo depuis l'URL
REPO_NAME=$(echo "$REPO_URL" | awk -F/ '{print $NF}' | sed 's/.git$//')

# Dossier de déploiement
DEPLOY_DIR="$EXTERNAL_BASE_DIR/$REPO_NAME"

# Injecter le PAT dans l'URL pour l'authentification
AUTH_URL=$(echo "$REPO_URL" | sed "s|https://|https://$PAT@|")

echo "Déploiement de '$REPO_NAME' depuis la branche '$ENV'..."

# Supprimer l'ancien dossier si existant
if [ -d "$DEPLOY_DIR" ]; then
  echo "Suppression de l'ancien déploiement..."
  rm -rf "$DEPLOY_DIR"
fi

# Cloner le repo sur la branche ENV
git clone --branch "$ENV" "$AUTH_URL" "$DEPLOY_DIR"

# Initialiser et mettre à jour les submodules avec le PAT
cd "$DEPLOY_DIR"
git submodule init
# Remplacer les URLs pour https et ssh avec le PAT
git -c url."https://$PAT@github.com/".insteadOf="https://github.com/" \
    -c url."https://$PAT@github.com/".insteadOf="git@github.com:" \
    submodule update --recursive

echo "Déploiement terminé avec succès dans $DEPLOY_DIR !"
