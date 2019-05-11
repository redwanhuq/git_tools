#!/bin/bash
# This is a pre-commit hook that will reject a commit if any .py file in the
# commit fails to meet PEP257 standards for Python docstrings. If a commit is 
# rejected, the hook will exit with a value of one.

# Iterate over all files in staging area
for file in `git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//'`
do
    # Check whether .py files meet PEP8 standards using pycodestyle linter
    if [[ $file == *py ]]
    then
        echo "Checking if $file meets PEP257 standards..."
        pydocstyle $file || exit 1
    fi
done