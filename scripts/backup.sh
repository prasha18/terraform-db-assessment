#!/bin/bash

set -e

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="hoteldb"
DB_USER="postgres"
BACKUP_DIR="/home/ubuntu/terraform-db-assessment/database/backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/hoteldb_$TIMESTAMP.sql"

echo "Starting backup..."

PGPASSWORD=postgres pg_dump \
-h $DB_HOST \
-p $DB_PORT \
-U $DB_USER \
-d $DB_NAME \
-F p \
-f "$BACKUP_FILE"

echo "Backup completed."

echo "Backup saved to:"
echo "$BACKUP_FILE"
