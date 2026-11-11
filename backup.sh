#!/bin/bash
# backup.sh - create a timestamped .tar.gz backup of a folder
# Usage: ./backup.sh <folder-to-backup> [backup-destination]

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <folder-to-backup> [backup-destination]"
  exit 1
fi

source_dir="$1"
dest_dir="${2:-./backups}"

if [ ! -d "$source_dir" ]; then
  echo "Error: '$source_dir' is not a folder."
  exit 1
fi

mkdir -p "$dest_dir"

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
folder_name=$(basename "$source_dir")
archive="$dest_dir/${folder_name}_${timestamp}.tar.gz"

tar -czf "$archive" -C "$(dirname "$source_dir")" "$folder_name"

size=$(du -h "$archive" | cut -f1)
echo "Backup created: $archive ($size)"

# Keep only the 5 most recent backups of this folder
ls -1t "$dest_dir"/"${folder_name}"_*.tar.gz | tail -n +6 | while read -r old; do
  rm -- "$old"
  echo "Removed old backup: $old"
done