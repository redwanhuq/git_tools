# Tools for git workflows

This repository contains tools that make git repositories cleaner or easier to maintain, or simply leverage the power of git to automate tasks. Here's what is included:

1. [Reverse gitignore file](#gitignore)
2. [Git hook runner](#hook-runner)
3. [Pre-commit hooks](#pre-commit)
4. [Documentation generation](#autodocs)

## Contents of repository

<a name="gitignore"></a>
### 1. Reverse gitignore file
A `.gitignore` is a list of all file types and/or individual files that are allowed in a repository; it helps keep a repository clean. Unlike a typical `.gitignore`, which is a blacklist, a reverse `.gitignore` is a whitelist; thus, more stringent and allows for more careful regulation of files.

`.gitignore` should be located in the top-level directory of a repository.

<a name="hook-runner"></a>
### 2. Git hook runner
`hook_runner.sh` is a Bash script that automatically detects and executes scripts when a particular type of git command is performed; these scripts are called **git hooks**. Both the hook runner and the hooks are stored in the `hooks` directory, which should be located in the top-level directory of a repository. 

Under the hood, the hook runner creates symlinks of hooks stored in the directory `hooks` to the directory `.git/hooks`, makes each script an executable, and then executes them. Hooks are detected by the type of git command enabled in the hook runner. By default, hooks related to the following commands are enabled:

- pre-commit: executed before performing a `git commit` (stored in directory `hooks/pre-commit`)
- pre-push: executed before performing a `git push` (stored in directory `hooks/pre-push`)

Hooks are executed in the order specified by the prefix found in their filenames. For example, `01-file_size.pl` will be executed before `02-pycodestyle_check.sh`.

#### Installation
Navigate to the top-level directory of the repository and enter:

```bash
$ chmod +x hooks/hook_runner.sh
$ ./hooks/hook_runner.sh install
```

No confirmation messages will be shown. These commands ensures the hook runner is an executable and prepares the symlinks. 

<a name="pre-commit"></a>
### 3. Pre-commit hooks
The following pre-commit hooks are included in this repository:

#### Ensuring python code is properly formatted
`01-black_check.sh` is a Bash script that identifies python files that have not been properly formatted as defined by the autoformatter [black](https://black.readthedocs.io/en/stable/). The command line argument `-S` is used with black to ignore its preference for using double quotes in strings.

Note that a commit containing files that should be formatted will *not* be rejected; this encourages a developer to format these files in a subsequent commit. Please ensure black is installed in the environment prior to using this hook.

#### Preventing large files from being added to repository
`02-file_size_check.sh` is a Bash script that prevents adding files to the local repository that exceed a size threshold; useful for avoiding repository bloat. The default size threshold is 100 KB but can be customized in the script.

Note that a commit containing large files will be rejected&mdash;the files should be unstaged before committing again. 

#### Ensuring python code adheres to code quality standards
`03-pycodestyle_check.sh` is a Bash script that identifies python files that fail to meet PEP8 standards for code style using the linter [pycodestyle](http://pycodestyle.pycqa.org/en/latest/). The maximum line length monitored by pycodestyle is changed to 88 characters to match the restriction in the autoformatter black. 

Note that a commit containing files with PEP8 violations will *not* be rejected; this encourages a developer to address these violations in a subsequent commit. Please ensure pycodestyle is installed in the environment prior to using this hook.

#### Ensuring python code adheres to docstring standards
`04-pydocstyle_check.sh` is a Bash script that identifies python files that fail to meet PEP257 standards for docstrings using the linter [pydocstyle](http://www.pydocstyle.org/en/4.0.0/). 

Note that a commit containing files with PEP257 violations will *not* be rejected; this encourages a developer to address these violations in a subsequent commit. Please ensure pydocstyle is installed in the environment prior to using this hook.

<a name="autodocs"></a>
### 4. Documentation generation
Documentation for python files can be automatically generated using the package [sphinx](http://www.sphinx-doc.org/en/master/).

After installing sphinx in the environment, enter `sphinx-quickstart` and elect to set up a separate a directory `source` containing `conf.py` with default values and a master document `index.rst`. Move `source` into a new top-level directory `doc`.

#### Sphinx configurations
For `conf.py`:

- Added `sphinx.ext.autodoc` extension that generates documentation from docstrings in python files
- Added `sphinx.ext.autosectionlabel` extension that enables referring to sections in RST files via their section title; useful for creating anchors
- Added appropriate path to `sys.path` to recognize python files such as `src/example.py`
- Added `sphinx_rtd_theme` as a custom HTML theme. Please ensure `sphinx_rtd_theme` is installed in the environment prior to building documentation.

For `Makefile`:

- Updated `SOURCEDIR` and `BUILDDIR` parameters with updated location of directories `source` (`doc/source`) and `build` (`doc/build`), respectively

#### Building documentation automatically using a pre-push hook
`01-create_docs.sh` is a Bash script that builds documentation using sphinx before a `git push` is performed. `src/example.py` is included as an example python file for testing this hook.