#!/bin/bash

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
source "${ROOT_DIR}/../lib/import.sh"

### App logic follows
###############################################################################

info "This is an information message"
error "And this is an error message"
echo
info "<-- Notice the main script entrypoint is printed here. It is quite long, though"
info "Try creating a friendly symlink"
info "ln -s ${ROOT_DIR}/${0##*/} /usr/local/bin/tutorial"
_color_message="$(__add_emphasis_green '$ tutorial')"
echo
info "Type $(__add_emphasis_red 'no') and try creating the friendly symlink before continuing"
get_user_input "If you've already done this, type $(__add_emphasis_green 'yes') to continue"

echo
info "Now you can run the friendly command directly like so: ${_color_message}"
info "<-- Notice the script tag picked up your symlink name"

echo
info "You"
info "$(__add_emphasis_blue can)"
info "$(__add_emphasis_red also)"
info "$(__add_emphasis_green print)"
info "$(__add_emphasis_gray in)"
info "$(__add_emphasis_magenta color)"

echo
info "=================================="
info "*            COMMANDS            *"
info "=================================="

echo
info "$(__add_emphasis_blue get_user_input)"
info "$(__add_emphasis_blue --------------)"
info "This acts like a modal dialog."
info "You can ask for use input to continue or stop execution."
echo
info "get_user_input <message_question> <message_if_yes> <message_if_no> <message_confirmation>"
info "- message_question:       Question prompt for the user"
info "- message_if_yes:         Feedback message when chosing to continue"
info "- message_if_no:          Feedback message when chosing to halt execution"
info "- message_confirmation:   Prompt for highlighting valid choices"
echo
info "DEMO"
info "get_user_input \"This is the main prompt\" \"Continuing execution\" \"Stopping execution\" \"Yes or No, please!\""
get_user_input "This is the main prompt" "Continuing execution" "Stopping execution" "Yes or No, please!"

echo
info "$(__add_emphasis_blue run_cmd)"
info "$(__add_emphasis_blue -------)"
info "This is the generic wrapper command."
info "It has many parameters, but only the first 2 are mandatory."
echo
info "run_cmd <command> <message> [<strict>] [<print_cmd>] [<decorate_output>] [<print_output>] [<print_message>] [<print_status>] [<print_outcome>] [<strict_message>] [<no_strict_message>] [<fail_message>]"
echo
info "DEMO"
info "run_cmd \"sleep 2\" \"Waiting for 2 seconds\""
run_cmd "sleep 2" "Waiting for 2 seconds"

echo
info "$(__add_emphasis_blue run_cmd_silent)"
info "$(__add_emphasis_blue --------------)"
info "This is a simpler interface to the generic run_cmd function."
info "You can use it for commands where the output is irrelevant, only the exit code."
info "The commands should also be quick enough, to do produce a long wait without user feedback."
echo
info "run_cmd_silent <command> <message> <fail_message>"
echo
info "DEMO"
info "run_cmd_silent \"echo 'foo' | grep 'bar'\" \"Checking regex\" \"Regex match failed\""
run_cmd_silent "echo 'foo' | grep 'bar'" "Checking regex" "Regex match failed, but we can continue execution"
info "This will execute too"

echo
info "$(__add_emphasis_blue run_cmd_silent_strict)"
info "$(__add_emphasis_blue ---------------------)"
info "This works the same as run_cmd_silent, except that when the command fails, the parent script will also throw an exit code and stop executing."
info "You can use this as fail-fast gate for your workflow."
info "The commands should also be quick enough, to do produce a long wait without user feedback."
echo
info "run_cmd_silent_strict <command> <message> <fail_message>"
echo
info "DEMO"
info "run_cmd_silent_strict \"echo 'foo' | grep 'bar'\" \"Checking regex\" \"Regex match failed\""
run_cmd_silent_strict "echo 'foo' | grep 'bar'" "Checking regex" "Regex match failed, and we're not going further. Main script is returning exit code != 0"
info "This will no longer execute"
