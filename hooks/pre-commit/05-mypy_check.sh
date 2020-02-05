#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit contains type
# hinting errors as detected by the linter mypy. Note that a commit containing files
# with errors will not be rejected.

# Collect files in staging area
staged_files="$(git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//')"

for file in $staged_files; do
  # Check whether file exists and is a python file
  if [[ -f $file && $file == *py ]]; then
    # Process python file using the linter mypy and record console output if errors are
    # present
    output=$(mypy $file --no-error-summary)

    # Display warning if type hinting errors exist
    if [[ -n "$output" ]]; then
      echo "WARNING: $file contains type hinting errors"
      echo "View errors by entering: mypy $file"
      echo
    fi
  fi
done
exit 0