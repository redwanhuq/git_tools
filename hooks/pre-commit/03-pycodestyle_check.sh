#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit fails to meet
# PEP8 standards for code style. The maximum line length monitored by pycodestyle is
# changed to 88 characters to match the restriction in the autoformatter black. Note
# that a commit containing files with violations will not be rejected.

# Collect files in staging area
staged_files="$(git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//')"

for file in $staged_files; do
  # Check whether file exists and is a python file
  if [[ -f $file && $file == *py ]]; then
    # Process python file using the linter pycodestyle and record console output
    output=$(pycodestyle --max-line-length=88 -q $file)

    # Display warning if any PEP8 violations exist
    if [[ -n "$output" ]]; then
      echo "WARNING: $file does not meet PEP8 standards for code style"
      echo "View violations by entering: pycodestyle --max-line-length=88 $file"
      echo
    fi
  fi
done
exit 0