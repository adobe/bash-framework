# bash-framework
Provides a shared code base for simple Bash scripts

## Usage

###  Step 0. Set the framework version that you want to use
```bash
_FRAMEWORK_VERSION='0.6.1'
```

###  Step 1. Add the framework repository as a submodule in your bash script project/repo
```bash
cd my_bash_project
git submodule add git@git.corp.adobe.com:mob-sre-tools/bash-framework.git vendor/bash-framework    # get source code
git commit -m 'imported mob-sre-tools/bash-framework as a submodule'                               # save submodule reference to top-level repo
```

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
### Framework boilerplate
###############################################################################
# calculate script root dir
export ROOT_DIR=$(cd ${BASH_SOURCE[0]%/*}/.. && pwd -P)

# import bash framework
source "${ROOT_DIR}/vendor/bash-framework/lib/import.sh"
```
