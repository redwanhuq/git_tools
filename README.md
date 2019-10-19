# Tools for continuous integration (CI)

Continuous integration is the process of frequently integrating code from a development team, while simultaneously verifying that the code meets certain build requirements. The build requirements may require code to pass a linting standard, contain docstrings, pass unit tests, etc. 

Because these requirements are checked automatically, additional scripts may be run during the integration process such as documentation generation and enforcing of commit best practices.

## Contents of repository

### Reverse gitignore file
`.gitignore` is a white list that ignores all file types unless specified. Unlike a typical gitignore, a reverse gitignore is more stringent, allowing one to carefully regulate which file types are permitted in a repository.

`.gitignore` should be located in the top-level directory of the repository.

### Git hook runner
`hook_runner.sh` is a shell script that automatically executes any git hooks present in the `hooks` directory. Specifically, this script creates symlinks of scripts in the `hooks` directory to the `.git/hooks` directory, makes each script an executable, and then executes them.

Hooks are executed as triggered by the git actions enabled in `hook_runner.sh`. Hooks are executed in the order specified by the prefix found in their filenames. For example, `01-file_size.pl` will be executed before `02-pycodestyle_check.sh`. The following triggers are enabled by default:

- `pre-commit`: executed before completing a `git commit` (stored in `hooks/pre-commit` directory)
- `pre-push`: executed before completing a `git push` (stored in `hooks/pre-push` directory)


#### Installation
Navigate to the top-level repository directory and enter:

```
$ chmod +x hooks/hook_runner.sh
$ ./hooks/hook_runner.sh install
```

These commands ensure `hook_runner.sh` is an executable and prepares the symlinks. 

### Pre-commit hook for preventing large files from being added to repository
`01_file_size.pl` is a Perl script that prevents any file that exceeds a size threshold from being added to the local repository; used to avoid repository bloat. The threshold can be customized in the script.

### Pre-commit hook for ensuring Python code adheres to code quality standards
`02-pycodestyle_check.sh` is a Bash script that identifies any `.py` files that fail to meet PEP8 standards for code style using the linter `pycodestyle`. Note that a commit containing files with violations will not be rejected; this enables a developer to address these violations in a future commit.

Note that `pycodestyle` must be installed prior to using this hook.

### Pre-commit hook for ensuring Python code adheres to docstring standards
`03-pydocstyle_check.sh` is a Bash script that identifies any `.py` files that fail to meet PEP257 standards for docstrings using the linter `pydocstyle`. Note that a commit containing files with violations will not be rejected; this enables a developer to address these violations in a future commit.

Note that `pydocstyle` must be installed in the environment prior to using this hook.

### Pre-commit hook for verifying Python code is properly formatted
`04-black_check.sh` is a Bash script that identifies any `.py` files that should be
processed using the autoformatter `black` to ensure proper formatting. Note that a commit containing files that should be formatted will not be rejected; this enables a developer to format these files in a future commit.

Note that `pydocstyle` must be installed in the environment prior to using this hook.

### Documentation generation setup
Documentation for Python files can be generated using `sphinx`. 

After installing `sphinx` in the environment, enter `sphinx-quickstart` and elect to set up a separate a `source` directory containing `conf.py` with default values and a master document `index.rst`. Move the `source` directory into a new top-level `doc` directory.

`src/example.py` is included as an sample module for generating documentation.

#### Included `sphinx` configurations
For `conf.py`:

- Add `sphinx.ext.autodoc` extension that generates documentation from Python docstrings
- Add `sphinx.ext.autosectionlabel` extension that enables referring to sections in RST files via the section title; useful for creating anchors
- Add appropriate path to `sys.path` to recognize Python files such as `src/example.py`
- Add `sphinx_rtd_theme` as custom HTML theme. `sphinx_rtd_theme` must be installed in the environment prior to building documentation.

For `Makefile`:

- Update `SOURCEDIR` and `BUILDDIR` parameters with updated location of `source` and `build`, respectively

#### Pre-push hook that builds documentation
`01-create_docs.sh` is a shell script that builds documentation using `sphinx` before a `git push` is completed.