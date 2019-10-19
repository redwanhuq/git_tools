#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit fails to meet
# PEP257 standards for docstrings. Note that a commit containing violations will not be
# rejected.

# Iterate over all files in staging area
for file in `git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//'`
do
    # Check whether .py files meet PEP257 standards using pydocstyle linter
    if [[ $file == *py ]]
    then
        echo "Checking if $file meets PEP257 standards..."
        pydocstyle $file
        echo
        exit 1
    fi
done