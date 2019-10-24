#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit has not been
# processed through the autoformatter black. The command line argument -S is used with
# black to ignore its preference for using double quotes in strings. Note that a commit
# containing files that should be formatted will not be rejected.

# Collect files in staging area
staged_files="$(git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//')"

for file in $staged_files; do
  # Check whether file exists and is a python file
  if [[ -f $file && $file == *py ]]; then
    # Check if python can be processed using the autoformatter black -S
    output=$(black --check -S $file 2>&1)

    # Display warning if file was not processed
    if [[ $output == *"reformatted"* ]]; then
      echo "WARNING: $file is not formatted properly"
      echo "Format file by entering: black -S $file"
      echo
    fi
  fi
done
exit 0