#!/usr/bin/env bash

# hook_runner is a framework for detecting and executing git hooks. The framework
# automatically creates symlinks of all scripts in the hooks directory, makes each
# script an executable, and then executes them.

install() {
    # Un-comment to select which git actions trigger a hook
    hook_types=(
        # "applypatch-msg"
        # "commit-msg"
        # "post-applypatch"
        # "post-checkout"
        # "post-commit"
        # "post-merge"
        # "post-receive"
        # "post-rewrite"
        # "post-update"
        # "pre-applypatch"
        # "pre-auto-gc"
        "pre-commit"
        "pre-push"
        # "pre-rebase"
        # "pre-receive"
        # "prepare-commit-msg"
        # "update"
    )

    # Create symlinks of scripts in hooks directory to .git/hooks directory if they 
    # already do not exist
    repo_root=$(git rev-parse --show-toplevel)
    hooks_dir="$repo_root/.git/hooks"
    link_target="../../hooks/hook_runner.sh"
    for hook_type in "${hook_types[@]}"
    do
        hook_symlink="$hooks_dir/$hook_type"
        if [ ! -f "$hook_symlink" ]
        then
            ln -s "$link_target" "$hook_symlink"
        fi
    done
}

main() {
    calling_file=$(basename $0)

    # Run only during initial installation
    if [[ $calling_file == "hook_runner.sh" ]]
    then
        command=$1
        if [[ $command == "install" ]]
        then
            install
        fi
    else
        # Identify hook types in hooks directory and .git/hooks directory, and number of
        # scripts present of each type
        repo_root=$(git rev-parse --show-toplevel)
        hook_type=$calling_file
        symlinks_dir="$repo_root/hooks/$hook_type"
        files=("$symlinks_dir"/*)
        number_of_symlinks="${#files[@]}"
        if [[ $number_of_symlinks == 1 ]]
        then
            if [[ "$(basename ${files[0]})" == "*" ]]
            then
                number_of_symlinks=0
            fi
        fi

        # Run scripts if present
        if [[ $number_of_symlinks -gt 0 ]]
        then
            echo "Running $number_of_symlinks $hook_type hook(s)..."
            echo

            hook_exit_code=0
            for file in "${files[@]}"
            do
                scriptname=$(basename $file)
                echo "Initiating hook: $scriptname"
                echo

                # Make script an executable
                chmod +x $file

                # Run script
                eval $file
                script_exit_code=$?
                if [[ $script_exit_code != 0 ]]
                then
                    hook_exit_code=$script_exit_code
                fi
            done
            
            # Reject commit if pre-commit hook yielded an exit code other than zero,
            # otherwise add commit to local repository
            if [ $hook_type == "pre-commit" ]
            then
                if [ $hook_exit_code != 0 ]
                then
                    echo "Commit was NOT added to local repository..."
                    echo "Please address any ERROR above and then try again"
                    exit $hook_exit_code
                else
                    echo "Commit was successfully added to local repository"
                    echo
                fi
            fi            
        fi
    fi
}

main "$@"