#!/bin/bash

# Script d'installation et de configuration d'un GitHub Actions Runner sur Linux
# Usage: ./github-runner.sh


set -e

# Charger la config globale
source "$(cd "$(dirname "$0")/../../" && pwd)/config.env"


# Demander les informations nécessaires
echo "Configuration du GitHub Actions Runner"
read -p "Entrez l'URL du repo ou de l'organisation (ex: https://github.com/owner/repo): " REPO_URL
read -p "Entrez le token d'enregistrement du runner: " RUNNER_TOKEN
read -p "Entrez le nom du runner: " RUNNER_NAME

# Créer un dossier pour le runner dans EXTERNAL_GITHUB_RUNNER_DIR
mkdir -p "$EXTERNAL_GITHUB_RUNNER_DIR"
cd "$EXTERNAL_GITHUB_RUNNER_DIR"

# Installer les dépendances nécessaires
sudo apt update
sudo apt install curl wget grep coreutils gawk -y


# Version et hash du runner à installer
RUNNER_VERSION="2.332.0"
RUNNER_HASH="f2094522a6b9afeab07ffb586d1eb3f190b6457074282796c497ce7dce9e0f2a"

# Télécharger le binaire du runner
echo "Téléchargement du GitHub Actions Runner v$RUNNER_VERSION..."
RUNNER_PKG="actions-runner-linux-x64-$RUNNER_VERSION.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/$RUNNER_PKG"
curl -o "$RUNNER_PKG" -L "$RUNNER_URL"

# Extraire le runner
tar xzf "$RUNNER_PKG"

bash "$GITHUB_RUNNER_DIR/config.sh" "$REPO_URL" "$RUNNER_TOKEN" "$RUNNER_NAME"
