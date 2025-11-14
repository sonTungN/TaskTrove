#!/bin/bash

# backup-tasktrove.sh
# Automated backup script for TaskTrove data

# Set the backup directory (change this to your preferred backup location)
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="tasktrove-backup-$DATE.tar.gz"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Starting TaskTrove backup..."

# Optional: Stop the container for a consistent backup
# Uncomment the lines below if you want to stop the container during backup
# docker stop tasktrove
# sleep 2

# Create compressed backup of the data directory
if [ -d "./data" ]; then
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" ./data
    
    if [ $? -eq 0 ]; then
        echo "✓ Backup completed successfully: $BACKUP_NAME"
        echo "  Location: $BACKUP_DIR/$BACKUP_NAME"
        
        # Keep only last 7 backups (optional cleanup)
        cd "$BACKUP_DIR"
        BACKUP_COUNT=$(ls -t tasktrove-backup-*.tar.gz 2>/dev/null | wc -l)
        if [ "$BACKUP_COUNT" -gt 7 ]; then
            echo "  Cleaning old backups (keeping 7 most recent)..."
            ls -t tasktrove-backup-*.tar.gz | tail -n +8 | xargs rm -f
        fi
    else
        echo "✗ Backup failed!"
        exit 1
    fi
else
    echo "✗ Error: ./data directory not found!"
    exit 1
fi

# Optional: Restart the container if you stopped it
# Uncomment the line below if you stopped the container
# docker start tasktrove

echo "Backup process complete."

