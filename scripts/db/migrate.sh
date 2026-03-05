#!/bin/bash
# filepath: /home/ubuntu/sqlserver/backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="master"
BACKUP_DIR="/home/ubuntu/sqlserver/sqlbackups"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$DATE.bak"

# Crée le répertoire de sauvegarde dans le conteneur s'il n'existe pas
docker exec sqlserver mkdir -p /var/opt/mssql/backups

# Lance la sauvegarde dans le conteneur SQL Server
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
   -S localhost -U SA -P 't1BhSgBHPNENGhK2yCLz' \
   -C -Q "BACKUP DATABASE [$DB_NAME] TO DISK = N'/var/opt/mssql/backups/${DB_NAME}_$DATE.bak' WITH NOFORMAT, NOINIT, NAME = '${DB_NAME}-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

# Copie la sauvegarde du conteneur vers l'hôte
docker cp sqlserver:/var/opt/mssql/backups/${DB_NAME}_$DATE.bak "$BACKUP_FILE"

echo "Sauvegarde créée : $BACKUP_FILE"

rclone copy "$BACKUP_FILE" RaveOnDev_GoogleDrive:Dev/VPS/sqlserver/Backups --progress

echo "Sauvegarde exportée sur Google Drive : $BACKUP_FILE"