#!/bin/bash

set -e

DB_HOST="localhost"
DB_PORT="5432"
DB_USER="postgres"
NEW_DB="hoteldb_restore"

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: ./restore.sh <backup-file>"
    exit 1
fi

echo "Dropping database if it exists..."

PGPASSWORD=postgres dropdb \
-h $DB_HOST \
-p $DB_PORT \
-U $DB_USER \
--if-exists \
$NEW_DB

echo "Creating new database..."

PGPASSWORD=postgres createdb \
-h $DB_HOST \
-p $DB_PORT \
-U $DB_USER \
$NEW_DB

echo "Restoring backup..."

PGPASSWORD=postgres psql \
-h $DB_HOST \
-p $DB_PORT \
-U $DB_USER \
-d $NEW_DB \
-f "$BACKUP_FILE"

echo "Restore completed successfully."
