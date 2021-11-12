# Copyright (c) 2017 - present Adobe Systems Incorporated. All rights reserved.

# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# https://opensource.org/licenses/MIT

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### Dependencies
###############################################################################
# depends_on: [ base_utils.sh ]
###############################################################################

###############################################################################
#### string colorizing
###############################################################################
__add_emphasis_blue() {
    local string="${1}"
    echo -en "\033[34m${string}\033[0m"
}

__add_emphasis_red() {
    local string="${1}"
    echo -en "\033[31m${string}\033[0m"
}

__add_emphasis_green() {
    local string="${1}"
    echo -en "\033[32m${string}\033[0m"
}

__add_emphasis_magenta() {
    local string="${1}"
    echo -en "\033[35m${string}\033[0m"
}

__add_emphasis_gray() {
    local string="${1}"
    echo -en "\033[30;1m${string}\033[0m"
}

###############################################################################
#### basic logging functions
###############################################################################
info() {
    _format="$(__add_emphasis_gray [$(get_entrypoint_script)]$(get_script_section)) %s\n"
    message=${1}
    printf "${_format}" "${message}"
}

error() {
    _format="$(__add_emphasis_red [$(get_entrypoint_script)]$(get_script_section)) %s\n"
    message=${1}
    printf "${_format}" "${message}"
}

debug() {
    message=${1}
    [ -n "${__tfm_DEBUG}" ] && echo -en "${message}" >> /tmp/tf.log
}

###############################################################################
#### log stream decorators
###############################################################################
decorate_error() {
    local _format="$(__add_emphasis_red [$(get_entrypoint_script)]$(get_script_section)) %s\n"

    # decorate output
    while read line; do printf "${_format}" "$line"; done
}

__decorate_cmd_output() {
    local _custom_label="${1}"
    # local _cmd_format="\e[34m[${_custom_label}]\e[0m %s\n"
    local _cmd_format="$(__add_emphasis_blue [${_custom_label}]) %s\n"

    # decorate command output
    while read line; do printf "${_cmd_format}" "$line"; done
}

