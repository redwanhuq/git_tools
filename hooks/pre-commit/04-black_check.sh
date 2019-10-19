#!/bin/bash
# This is a pre-commit hook that will warn if any .py file in a commit has not been
# processed through the autoformatter black using the argument -S (prevents single
# quotes from being transformed to double quotes). Note that a commit containing files
# that should be formatted will not be rejected.

# Iterate over all files in staging area
for file in `git diff --staged --name-status | sed -e '/^D/ d; /^D/! s/.\s\+//'`
do
    # Check whether .py files meet PEP257 standards using pydocstyle linter
    if [[ $file == *py ]]
    then
        OUTPUT=$(black --check -S $file 2>&1)
        if [[ $OUTPUT == *"reformatted"* ]]
        then
            echo "WARNING: $file is not formatted properly"
            echo "Format file by entering: black -S $file"
            echo
        fi
    fi
done
exit 0