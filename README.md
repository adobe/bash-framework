# bash-framework
A collection of helper bash functions used to create lightweight and portable CLI wrappers for other tools.

## Features
- create portable bash scripts that follow a similar workflow and format
- re-use helper functions across projects
- write less boilerplate code and reduce duplication across projects (I'm looking at you, helper functions)
- minimal runtime requirements
- trackable/upgradable using a language agnostic tool (git)

## Requirements
- bash
- readlink

## Usage
This procedure describes the steps required for starting a Bash project that
uses the framework.

###  Step 0. Set the framework version that you want to use
```bash
_FRAMEWORK_VERSION='0.8.0'
```

###  Step 1. Add the framework repository as a submodule in your bash script project/repo
```bash
cd my_bash_project
git submodule add git@github.com:adobe/bash-framework.git vendor/bash-framework     # get source code
git commit -m 'imported bash-framework as a submodule'                              # save submodule reference to top-level repo
```
**Note:**
A hard copy would also work of course, but the git submodule approach enables clear framework version tracking and also provides an elegant upgrade workflow, without introducing any 3rd party tools besides git (which I assume you are already using).

###  Step 2. Pin the desired version
```bash
cd vendor/bash-framework
git checkout ${_FRAMEWORK_VERSION}
cd -
git add vendor/bash-framework
git commit -m "fixed bash framework version @ ${_FRAMEWORK_VERSION}"
```

###  Step 3. Import framework into your code
```bash
### Platform check
###############################################################################
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

### Binary set
###############################################################################
case "${machine}" in
    Linux*)     BIN_READLINK="readlink";;
    Mac*)       BIN_READLINK="greadlink";;
    *)          BIN_READLINK="readlink";;
esac

### Framework boilerplate
###############################################################################
# calculate script root dir
ROOT_DIR="$( dirname $(${BIN_READLINK} -f ${BASH_SOURCE[0]}) )"

# import bash framework
source "${ROOT_DIR}/vendor/bash-framework/lib/import.sh"
```

###  Step 4. Use the basic functionality
Please refer to the [examples](examples) folder for functional demos of this library.
