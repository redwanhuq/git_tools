#!/usr/bin/perl
# This is a pre-commit hook that will reject a commit if size of any file in
# the commit execeeds a threshold. If a commit is rejected, the hook will exit
# with a value of one.

use strict; 
use warnings;

# Set file size threshold in bytes. Default is 100 KB.
my $file;
my $MAX_SIZE = 100000;

# Gather list of added, copied, modified, or renamed files
my @new_file_list =  `git diff --cached --name-only --diff-filter=ACMR`;

# Iterate over each file in the commit
foreach $file (@new_file_list)
{
    # Remove new line character from filename if present
    chomp($file);

    # Check if file size exceeds threshold
    if (-s $file > $MAX_SIZE)
    {
        # Compute file sizes in kilobytes for displaying to console
        my $file_size_kb = (-s $file) / 1000;
        my $max_size_kb = $MAX_SIZE / 1000;

        print STDERR "ERROR: $file is $file_size_kb KB\n";
        print STDERR "Files above $max_size_kb KB cannot be committed\n";
        exit 1;
    }
}