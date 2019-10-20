#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit fails to meet
# PEP257 standards for docstrings. Note that a commit containing files with violations
# will not be rejected.

# Iterate over all files in staging area
for file in `git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//'`; do
    # Check whether .py files meet PEP257 standards using pydocstyle linter
    if [[ $file == *py ]]; then
        OUTPUT=$(pydocstyle $file)
        if [[ ! -z "$OUTPUT" ]]; then
            echo "WARNING: $file does not meet PEP257 standards for docstrings"
            echo "View violations by entering: pydocstyle $file"
            echo
        fi
    fi
done
exit 0