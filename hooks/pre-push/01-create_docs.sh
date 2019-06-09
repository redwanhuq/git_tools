#!/bin/bash
# This is a pre-push hook that will generate documentation using sphinx before
# a commit(s) is pushed to a repository.
make clean
make html