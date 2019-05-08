# Tools for continuous integration (CI)

Continuous integration is the process of frequently integrating code from a development team, while simultaneously verifying that the code meets certain build requirements. The build requirements may require code to pass a linting standard, contain docstrings, pass unit tests, etc. 

Because these requirements are checked automatically, additional scripts may be run during the integration process such as documentation generation and enforcing of commit best practices.

### Contents of repository

1. **Reverse gitignore file** (`.gitignore`): a white list that ignores all file types unless specified. Unlike a typical gitignore, a reverse gitignore is more stringent, allowing one to carefully regulate which file types are permitted in a repository.

2. **Git hook manager** (`autohook.sh`): a shell script that automatically creates symlinks of scripts in the `hooks` directory to the `.git/hooks` directory, makes each script an executable, and then executes them by hook type

3. **Pre-commit hook for file sizes** (`01_file_size.pl`): a Perl script that prevents committing any file that exceeds a size threshold, used to avoid repository bloat. The threshold can be customized in the script.

4. **Pre-push hook that does nothing** (`01-empty-hook.sh`): a empty shell script that can be configured to run when code is pushed to a remote repository

### Installing the git hook manager
Navigate to the repository directory and enter at the prompt

```
$ chmod +x hooks/autohook.sh
$ ./hooks/autohook.sh install
```

These commands will ensure the git hook manager is executable and prepare the symlinks. 

Afterwards, all hooks present in `hooks/pre-commit` or `hooks/pre-push` directories will be run after a `git commit` or `git push` command, respectively. Hooks will be executed in order specified by the prefix found in the filename. For example, `01_file_size.pl` will run before `02_hook.sh`.