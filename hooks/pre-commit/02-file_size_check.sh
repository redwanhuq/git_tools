#!/bin/bash
# This is a pre-commit hook that will reject a commit if the size of any file in the
# commit exceeds a threshold.

# Set file size threshold in bytes, default is 100 KB
MAX_SIZE=100000

found_errors=false

# Collect files in staging area
staged_files="$(git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//')"

for file in $staged_files; do
  # Compute file size only if file exists
  if [[ -f $file ]]; then
    filesize=$(stat -c%s "$file")

    # Check if file size exceeds threshold
    if [[ $filesize -gt $MAX_SIZE ]]; then
      # Compute file sizes in kilobytes for displaying to console
      filesize_kb=$(( filesize / 1000 ))
      max_size_kb=$(( MAX_SIZE / 1000 ))

      echo "ERROR: $file is too large ($filesize_kb KB); cannot exceed $max_size_kb KB"
      echo "Unstage the file by entering: git reset head $file"
      echo
      found_errors=true
    fi
  fi
done

# Reject commit if any file size exceeded threshold
if [[ $found_errors == true ]]; then
  exit 1
else
  exit 0
fi