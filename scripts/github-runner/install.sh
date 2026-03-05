#!/bin/bash

# Script d'installation et de configuration d'un GitHub Actions Runner sur Linux
# Usage: ./github-runner.sh


set -e

# Charger la config globale
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../config.env"
BASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Demander les informations nécessaires
read -p "Entrez l'URL du repo ou de l'organisation (ex: https://github.com/owner/repo): " REPO_URL
read -p "Entrez le token d'enregistrement du runner: " RUNNER_TOKEN
read -p "Entrez le nom du runner: " RUNNER_NAME


# Créer un dossier pour le runner dans BASE_DIR
RUNNER_DIR="$BASE_DIR/github-runner"
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

# Installer les dépendances nécessaires
sudo apt update
sudo apt install curl wget grep coreutils gawk -y

# Télécharger le dernier binaire du runner
echo "Téléchargement du GitHub Actions Runner..."
LATEST_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep browser_download_url | grep linux-x64 | cut -d '"' -f 4)

# Télécharger et extraire le runner
echo "Téléchargement de $LATEST_URL..."
wget "$LATEST_URL" -O actions-runner-linux-x64.tar.gz

tar xzf actions-runner-linux-x64.tar.gz

# Configurer le runner
./config.sh --url "$REPO_URL" --token "$RUNNER_TOKEN" --name "$RUNNER_NAME" --unattended

# Lancer le runner
./run.sh

echo "Runner GitHub Actions installé et lancé avec succès !"
