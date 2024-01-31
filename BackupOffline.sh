#!/bin/bash

# Check if a file name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <BackupListFile>"
    exit 1
fi

# File containing the list of directories to backup
BACKUP_LIST_FILE="$1"

# Extract the backup drive name from the file name
BACKUP_DRIVE_NAME=$(basename "$BACKUP_LIST_FILE" .txt)
BACKUP_DRIVE="/media/$USER/$BACKUP_DRIVE_NAME"
BACKUP_DIR="$BACKUP_DRIVE/Backup"

# Create Backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to perform the backup using rsync
backup_directory() {
    local source_dir=$1
    local dest_dir=$2
    local dir_name=$(basename "$source_dir")

    echo "Starting backup of $dir_name directory..."
    rsync -av "$source_dir" "$dest_dir/$dir_name"

    if [ $? -eq 0 ]; then
        echo "Backup of $dir_name completed successfully."
    else
        echo "Error: Backup of $dir_name failed." >&2
    fi
}

# Check if the backup drive is mounted
if mount | grep -q "$BACKUP_DRIVE"; then
    while IFS= read -r line; do
        [[ $line == "###" ]] && break  # Stop at '###' marker
        [[ -n $line ]] && backup_directory "$line" "$BACKUP_DIR"
    done < "$BACKUP_LIST_FILE"

    echo "All backups completed."

    # Append backup date/time and drive free space to the file
    {
        echo "Backup date/time: $(date)"
        echo "Drive Free Space: $(df -h | grep "$BACKUP_DRIVE" | awk '{print $4}')"
    } >> "$BACKUP_LIST_FILE"
    
    # Copy the updated BackupListFile to the backup drive
    cp "$BACKUP_LIST_FILE" "$BACKUP_DRIVE/"

    echo "Backup information appended to $BACKUP_LIST_FILE."
else
    echo "Error: Backup drive is not mounted." >&2
    exit 1
fi
