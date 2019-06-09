# Tools for continuous integration (CI)

Continuous integration is the process of frequently integrating code from a development team, while simultaneously verifying that the code meets certain build requirements. The build requirements may require code to pass a linting standard, contain docstrings, pass unit tests, etc. 

Because these requirements are checked automatically, additional scripts may be run during the integration process such as documentation generation and enforcing of commit best practices.

## Contents of repository

### Reverse gitignore file
`.gitignore` is a white list that ignores all file types unless specified. Unlike a typical gitignore, a reverse gitignore is more stringent, allowing one to carefully regulate which file types are permitted in a repository.

`.gitignore` should be located in the top-level directory of the repository.

### Git hook manager
`autohook.sh` is a shell script that runs git hooks after any commit or a push. Specifically, it automatically creates symlinks of scripts in the `hooks` directory to the `.git/hooks` directory, makes each script an executable, and then executes them by hook type.

#### Installation
Navigate to the top-level repository directory and enter:

```
$ chmod +x hooks/autohook.sh
$ ./hooks/autohook.sh install
```

These commands will ensure the git hook manager is executable and prepare the symlinks. 

Afterwards, all hooks present in `hooks/pre-commit` or `hooks/pre-push` directories will be run after a `git commit` or `git push` command, respectively. Hooks will be executed in order specified by the prefix found in the filename. For example, `01_file_size.pl` will run before `02-pycodestyle_check.sh`.

### Pre-commit hook for checking file sizes
`01_file_size.pl` is a Perl script that prevents committing any file that exceeds a size threshold, used to avoid repository bloat. The threshold can be customized in the script.

### Pre-commit hook for checking Python code style
`02-pycodestyle_check.sh` is a Bash script that examines whether `.py` files meet PEP8 standards using the linter `pycodestyle`, and displays warnings and errors for each file. 

`pycodestyle` must be installed in the environment prior to using this hook.

### Pre-commit hook for checking Python docstring style
`03-pydocstyle_check.sh` is a Bash script that examines whether `.py` files meet PEP257 standards using the linter `pydocstyle`, and displays warnings and errors for each file. 

`pydocstyle` must be installed in the environment prior to using this hook.

### Pre-push hook that does nothing
`01-empty-hook.sh` is a empty shell script that can be configured to run when code is pushed to a remote repository

### Documentation setup
Documentation for Python files can be generated using `sphinx`. 

After installing `sphinx`, enter `sphinx-quickstart` and elect to set up a separate `source` directory containing `conf.py` with default values and a master document `index.rst`. Move the `source` directory into a new top-level directory `doc`.

`src/example.py` is included as an example module for generating documentation. Useful configurations for `sphinx` are provided. Included configurations for `conf.py`:

- Add `sphinx.ext.autodoc` extension that generates documentation from Python docstrings
- Add `sphinx.ext.autosectionlabel` extension that enables referring to sections in RST files via the section title; useful for creating anchors
- Add appropriate path to `sys.path` to recognize Python files such as `src/example.py`

Included configurations for `Makefile`:

- Update `SOURCEDIR` and `BUILDDIR` parameters with updated location of `source` and `build`, respectively