#!/bin/bash

# Script d'installation et de configuration de la base de données SQL
# Usage: ./setup.sh [--env <environment>]

set -e

ENV="production"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --env) ENV="$2"; shift ;;
    *) echo "Option inconnue: $1"; exit 1 ;;
  esac
  shift
done

echo "Configuration de la base de données pour l'environnement '$ENV'..."

# Installer PostgreSQL si nécessaire
# sudo apt update && sudo apt install postgresql postgresql-contrib -y

# TODO: adapter selon ton moteur SQL (PostgreSQL, MySQL, SQLite)
# Exemple PostgreSQL :
# sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'mypassword';"
# sudo -u postgres psql -c "CREATE DATABASE mydb OWNER myuser;"
# sudo -u postgres psql -d mydb -f migrations/init.sql

echo "Base de données configurée avec succès !"
