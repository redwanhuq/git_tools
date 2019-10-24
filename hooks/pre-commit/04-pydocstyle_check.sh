#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit fails to meet
# PEP257 standards for docstrings. Note that a commit containing files with violations
# will not be rejected.

# Collect files in staging area
staged_files="$(git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//')"

for file in $staged_files; do
  # Check whether file exists and is a python file
  if [[ -f $file && $file == *py ]]; then
    # Process python file using the linter pydocstyle and record console output
    output=$(pydocstyle $file)

    # Display warning if any PEP257 violations exist
    if [[ -n "$output" ]]; then
      echo "WARNING: $file does not meet PEP257 standards for docstrings"
      echo "View violations by entering: pydocstyle $file"
      echo
    fi
  fi
done
exit 0