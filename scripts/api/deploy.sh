#!/bin/bash

# Script de déploiement de l'API
# Usage: ./deploy.sh [--env <environment>] [--tag <image_tag>]

set -e

ENV="production"
IMAGE_TAG="latest"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --env) ENV="$2"; shift ;;
    --tag) IMAGE_TAG="$2"; shift ;;
    *) echo "Option inconnue: $1"; exit 1 ;;
  esac
  shift
done

echo "Déploiement de l'API en environnement '$ENV' avec le tag '$IMAGE_TAG'..."

# TODO: adapter selon ton infrastructure (Docker, systemd, PM2, etc.)
# Exemple Docker :
# docker pull ghcr.io/votre-org/api:$IMAGE_TAG
# docker stop api || true
# docker rm api || true
# docker run -d --name api --env-file .env.$ENV -p 3000:3000 ghcr.io/votre-org/api:$IMAGE_TAG

echo "Déploiement terminé avec succès !"
