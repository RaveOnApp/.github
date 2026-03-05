#!/bin/bash

# Script d'installation et de configuration d'un GitHub Actions Runner sur Linux
# Usage: ./github-runner.sh


set -e

# Charger la config globale
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../config.env"


# Demander les informations nécessaires
read -p "Entrez l'URL du repo ou de l'organisation (ex: https://github.com/owner/repo): " REPO_URL
read -p "Entrez le token d'enregistrement du runner: " RUNNER_TOKEN
read -p "Entrez le nom du runner: " RUNNER_NAME

# Installation du GitHub Actions Runner
echo "Installation du GitHub Actions Runner..."


# Créer un dossier pour le runner dans BASE_DIR
RUNNER_DIR="$BASE_DIR/github-runner"
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

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


echo "Pour configurer le runner, lance :"
bash "$SCRIPT_DIR/config.sh" "$REPO_URL" "$RUNNER_TOKEN" "$RUNNER_NAME"
