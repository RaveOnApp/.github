#!/bin/bash

# Script de backup SQL Server
# Usage: ./backup.sh <CONNECTION_STRING> <OUTPUT_PATH>
#   CONNECTION_STRING : "Server=HOST,PORT;Database=DB_NAME;User Id=USER;Password=PASSWORD;TrustServerCertificate=True;"
#   OUTPUT_PATH       : Dossier de sortie pour la backup

set -e

# Charger la config globale
source "$(cd "$(dirname "$0")/../../" && pwd)/config.env"

# Récupérer les paramètres
if [ "$#" -eq 2 ]; then
  CONNECTION_STRING="$1"
  OUTPUT_PATH="$2"
else
  read -p "Chaîne de connexion (Server=HOST,PORT;Database=DB;User Id=USER;Password=PASS;...): " CONNECTION_STRING
  read -p "Dossier de sortie: " OUTPUT_PATH
fi

# Parser la chaîne de connexion ADO.NET style
DB_HOST=$(echo "$CONNECTION_STRING" | grep -oP '(?<=Server=)[^;,]+')
DB_PORT=$(echo "$CONNECTION_STRING" | grep -oP '(?<=,)\d+(?=;)' | head -1)
DB_NAME=$(echo "$CONNECTION_STRING" | grep -oP '(?<=Database=)[^;]+')
DB_USER=$(echo "$CONNECTION_STRING" | grep -oP '(?<=User Id=)[^;]+')
DB_PASSWORD=$(echo "$CONNECTION_STRING" | grep -oP '(?<=Password=)[^;]+')
DB_PORT="${DB_PORT:-1433}"

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$OUTPUT_PATH"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$DATE.bak"
LOGFILE="$EXTERNAL_LOGS_DIR/db_backup_$DATE.log"

mkdir -p "$BACKUP_DIR"
exec >> "$LOGFILE" 2>&1

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

# Check if SQL Server container is running
if ! docker ps --format '{{.Names}}' | grep -q "^sqlserver$"; then
  echo "$(timestamp) ERROR: The 'sqlserver' container is not running."
  exit 1
fi

# Create backup directory in container if needed
docker exec sqlserver mkdir -p /var/opt/mssql/backups

# Start SQL Server backup in the container
echo "$(timestamp) INFO: Starting SQL Server backup (DB: $DB_NAME)..."
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
   -S "$DB_HOST" -U "$DB_USER" -P "$DB_PASSWORD" \
   -C -Q "BACKUP DATABASE [$DB_NAME] TO DISK = N'/var/opt/mssql/backups/${DB_NAME}_$DATE.bak' WITH NOFORMAT, NOINIT, NAME = '${DB_NAME}-full', SKIP, NOREWIND, NOUNLOAD"

# Check if backup was created in the container
if ! docker exec sqlserver test -f /var/opt/mssql/backups/${DB_NAME}_$DATE.bak; then
  echo "$(timestamp) ERROR: Backup was not created in the container."
  exit 2
fi

# Copy backup from container to host
echo "$(timestamp) INFO: Copying backup file to host..."
if ! docker cp sqlserver:/var/opt/mssql/backups/${DB_NAME}_$DATE.bak "$BACKUP_FILE"; then
  echo "$(timestamp) ERROR: Failed to copy backup file to host."
  exit 3
fi
echo "$(timestamp) INFO: Copying backup file to host..."
if ! docker cp sqlserver:/var/opt/mssql/backups/${DB_NAME}_$DATE.bak "$BACKUP_FILE"; then
  echo "$(timestamp) ERROR: Failed to copy backup file to host."
  exit 3
fi

echo "$(timestamp) INFO: Backup created: $BACKUP_FILE"

# Check if backup exists on host before exporting
if [ ! -f "$BACKUP_FILE" ]; then
  echo "$(timestamp) ERROR: Backup file does not exist on host."
  exit 4
fi

# Export backup to Google Drive
echo "$(timestamp) INFO: Exporting backup to Google Drive..."
if ! rclone copy "$BACKUP_FILE" RaveOnDev_GoogleDrive:Dev/VPS/SqlServer/Backups; then
  echo "$(timestamp) ERROR: Failed to export backup to Google Drive."
  exit 5
fi

echo "$(timestamp) INFO: Backup exported to Google Drive: $BACKUP_FILE"
echo ""