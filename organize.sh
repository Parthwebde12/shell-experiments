#!/bin/bash
# organize.sh - sort files in a folder into subfolders by extension
# Usage: ./organize.sh [folder]   (defaults to current folder)

set -euo pipefail

target="${1:-.}"

if [ ! -d "$target" ]; then
  echo "Error: '$target' is not a folder."
  exit 1
fi

count=0
for file in "$target"/*; do
  # Skip folders and this script itself
  [ -f "$file" ] || continue
  [ "$(basename "$file")" = "organize.sh" ] && continue

  name=$(basename "$file")
  if [[ "$name" == *.* ]]; then
    ext="${name##*.}"
  else
    ext="no_extension"
  fi

  mkdir -p "$target/$ext"
  mv "$file" "$target/$ext/"
  echo "Moved: $name -> $ext/"
  count=$((count + 1))
done

echo "Done. Organized $count file(s)."