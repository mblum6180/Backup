#!/bin/bash

# Check if a file name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <BackupListFile>"
    exit 1
fi

# File containing the list of directories to restore
RESTORE_LIST_FILE="$1"

# Extract the backup drive name from the file name
BACKUP_DRIVE_NAME=$(basename "$RESTORE_LIST_FILE" .txt)
BACKUP_DRIVE="/media/$USER/$BACKUP_DRIVE_NAME"
BACKUP_DIR="$BACKUP_DRIVE/Backup"

# Function to perform the restoration using rsync
restore_directory() {
    local dest_dir=$1
    local source_dir="$BACKUP_DIR/$(basename "$dest_dir")"

    echo "Starting restoration of $(basename "$dest_dir") directory..."
    rsync -av --delete "$source_dir/" "$dest_dir/"

    if [ $? -eq 0 ]; then
        echo "Restoration of $(basename "$dest_dir") completed successfully."
    else
        echo "Error: Restoration of $(basename "$dest_dir") failed." >&2
    fi
}

# Check if the backup drive is mounted
if mount | grep -q "$BACKUP_DRIVE"; then
    while IFS= read -r line; do
        [[ $line == "###" ]] && break  # Stop at '###' marker
        [[ -n $line ]] && restore_directory "$line"
    done < "$RESTORE_LIST_FILE"

    echo "All restorations completed."
else
    echo "Error: Backup drive is not mounted." >&2
    exit 1
fi

