# Simple Backup and Restore Scripts

## Overview
These scripts provide a straightforward solution for backing up and restoring directories on a Unix-like system. They are designed to read a list of directory paths from a text file and use `rsync` to perform the backup and restoration processes.

## Files
- `Backup.sh`: Script to back up directories listed in a specified text file.
- `Restore.sh`: Script to restore directories from a backup location.
- `Template.txt`: Example of a text file containing a list of directories to be backed up or restored.

## Usage

### Backup.sh
To back up directories:
1. List the directories to be backed up in a text file, one directory per line.
2. Run the script with the text file as an argument: ./Backup.sh BackupListFile.txt
3. The script will back up the directories to a `Backup` directory on a specified backup drive.

### Restore.sh
To restore directories:
1. Ensure the text file contains the paths of the directories to be restored (same format as for backup).
2. Run the script with the text file as an argument: ./Restore.sh BackupListFile.txt
3. The script will restore the directories from the backup location to their original paths.

## Requirements
- `rsync`: This tool must be installed on your system to use these scripts.
- Unix-like environment (Linux, macOS).

## Notes
- The backup drive is determined based on the name of the text file (e.g., `Template.txt` corresponds to a drive `/media/$USER/Template`).
- The scripts handle directory paths with spaces.
- The backup script appends backup date/time and available drive space to the end of the text file.
- Ensure the backup drive is properly mounted before running these scripts.
- It's advisable to perform a test backup and restore with non-critical data before using the scripts for important data.

## Disclaimer
These scripts are provided "as is" without warranty of any kind. Use them at 
