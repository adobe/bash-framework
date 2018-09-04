### Dependencies
###############################################################################
# depends_on: [ message_printer.sh ]
###############################################################################

OK=$(printf "\xE2\x9C\x93")
OK=$(printf "\e[32m${OK}\e[0m")
FAIL=$(printf "\xE2\x9C\x97")
FAIL=$(printf "\e[31m${FAIL}\e[0m")

## global default run_cmd flags
_DEFAULT_CMD_FLAGS=(
    "no_strict"             # 0
    "no_print_cmd"          # 1
    "no_decorate_output"    # 2
    "print_output"          # 3
    "print_message"         # 4
    "print_status"          # 5
    "print_outcome"         # 6
    "aborting..."           # 7
    "continuing..."         # 8
)

## internal function that can
# - report pretty cmd status
# - abort whole script if running in strict mode
# - notify when cmd execution finishes
__parse_status() {
    # input vars
    __safe_set_bash_setting 'u'
    local message="${1}"
    local result="${2}"
    local strict="${3}"
    local print_message="${4}"
    local print_status="${5}"
    local print_outcome="${6}"
    local fail_message="${7}"
    local strict_message="${8}"
    local no_strict_message="${9}"
    __safe_unset_bash_setting 'u'

    # set decorators
    result_deco_open='['
    result_deco_close=']'
    outcome_deco_open='('
    outcome_deco_close=')'

    # happy flow
    label_color='30;1' # light gray
    result_message="${result_deco_open} ${OK} ${result_deco_close}"
    outcome_message="${outcome_deco_open}done${outcome_deco_close}"
    if [ $result -ne 0 ]; then
        # rather sad flow
        label_color='31' # red
        result_message="${result_deco_open} ${FAIL} ${result_deco_close}";
        outcome_message="${outcome_deco_open}stopped${outcome_deco_close}"
        # "oh, shit!" flow
        [ "${strict}" = 'strict' ] && result_message="${result_message} $(printf "\e[31m${strict_message}\e[0m")"
        [ "${strict}" = 'no_strict' ] && result_message="${result_message} $(printf "\e[31m${no_strict_message}\e[0m")"
    fi

    # set desired message length
    _message_length="99"

    # auto-adjust length in case the message itself contains colored string sequences
    _message_length=$(__adjust_length_to_colored_output "${message}" "${_message_length}")

    # set format
    _format="\e[${label_color}m[$(get_entrypoint_script)]$(get_script_section)\e[0m %-${_message_length}.${_message_length}s %s\n"

    # suppress the outcome suffix if flag is disabled
    [ "${print_outcome}" = "no_print_outcome" ] && outcome_message=''

    # repeat cmd message and notify for completion
    [ "${print_status}" = "print_status" ] && printf "${_format}" "${message} ${outcome_message}" "${result_message}"

    # failure handling
    if [ $result -ne 0 ]; then
        # print out custom error message if set
        [ -n "${fail_message}" ] && (>&2 printf "%s\n" "${fail_message}")

        # if strict flag is set on a failed command, then we also pass the exit code
        [ "${strict}" = 'strict' ] && exit $result
    fi
}

## internal command execution function that can
# - decorate cmd output
# - suppress cmd output
# - parse cmd status
__cmd_exec() {
    # input vars
    __safe_set_bash_setting 'u'
    local command="${1}"
    local decorate_output="${2}"
    local strict="${3}"
    local print_output="${4}"
    local print_message="${5}"
    local print_status="${6}"
    local print_outcome="${7}"
    local fail_message="${8}"
    local strict_message="${9}"
    local no_strict_message="${10}"
    __safe_unset_bash_setting 'u'

    local buffer='/dev/stdout'
    [ "${print_output}" = 'no_print_output' ] && buffer='/dev/null'

    # enable pipefail if it was disabled
    __safe_set_bash_pipefail

    # run the command and decorate the output if "decorate_output" is enabled
    if [ "${decorate_output}" = "decorate_output" ]; then
        bash -c "$command" &> ${buffer} | __decorate_cmd_output "${command%% *}"
        local result=$?
    else
        bash -c "$command" &> ${buffer}
        local result=$?
    fi

    # disable pipefail if it was not enabled
    __safe_unset_bash_pipefail

    # print status
    __parse_status "${message}" "${result}" "${strict}" "${print_message}" "${print_status}" "${print_outcome}" "${fail_message}" "${strict_message}" "${no_strict_message}"

    # pass command exit-code to caller
    return $result
}

run_cmd_silent() {
    # input vars
    __safe_set_bash_setting 'u'
    local command="${1}"
    local message="${2}"
    local fail_message="${3}"
    __safe_unset_bash_setting 'u'

    ## load default cmd_flags and override as needed
    cmd_flags=(${_DEFAULT_CMD_FLAGS[@]})
    cmd_flags[3]='no_print_output'
    cmd_flags[4]='no_print_message'
    cmd_flags[5]='no_print_status'
    cmd_flags[6]='no_print_outcome'

    ## execute validation
    run_cmd "${command}" "${message}" "${cmd_flags[@]}" "${fail_message}"
    local result=$?

    # log executed commands if flag is set
    debug "---\nCommand: ${command}\nResult: ${result}\n"

    # pass command exit-code to caller
    return ${result}
}

run_cmd_silent_strict() {
    # input vars
    __safe_set_bash_setting 'u'
    local command="${1}"
    local message="${2}"
    local fail_message="${3}"
    __safe_unset_bash_setting 'u'

    ## load default cmd_flags and override as needed
    cmd_flags=(${_DEFAULT_CMD_FLAGS[@]})
    cmd_flags[0]='strict'
    cmd_flags[3]='no_print_output'
    cmd_flags[4]='no_print_message'
    cmd_flags[5]='no_print_status'
    cmd_flags[6]='no_print_outcome'

    ## execute validation
    run_cmd "${command}" "${message}" "${cmd_flags[@]}" "${fail_message}"
    local result=$?

    # log executed commands if flag is set
    debug "---\nCommand: ${command}\nResult: ${result}\n"

    # pass command exit-code to caller
    return ${result}
}

run_cmd_strict() {
    # input vars
    __safe_set_bash_setting 'u'
    local command="${1}"
    local message="${2}"
    local fail_message="${3}"
    __safe_unset_bash_setting 'u'

    ## load default cmd_flags and override as needed
    cmd_flags=(${_DEFAULT_CMD_FLAGS[@]})
    cmd_flags[0]='strict'
    cmd_flags[3]='no_print_output'
    cmd_flags[4]='no_print_message'
    cmd_flags[6]='no_print_outcome'

    ## execute validation
    run_cmd "${command}" "${message}" "${cmd_flags[@]}" "${fail_message}"
    local result=$?

    # log executed commands if flag is set
    debug "---\nCommand: ${command}\nResult: ${result}\n"

    # pass command exit-code to caller
    return ${result}
}

## public function for users to call for running commands
run_cmd() {
    # input vars
    __safe_set_bash_setting 'u'
    local command="${1}"
    local message="${2:-}"
    local strict="${3:-${_DEFAULT_CMD_FLAGS[0]}}"
    local print_cmd="${4:-${_DEFAULT_CMD_FLAGS[1]}}"
    local decorate_output="${5:-${_DEFAULT_CMD_FLAGS[2]}}"
    local print_output="${6:-${_DEFAULT_CMD_FLAGS[3]}}"
    local print_message="${7:-${_DEFAULT_CMD_FLAGS[4]}}"
    local print_status="${8:-${_DEFAULT_CMD_FLAGS[5]}}"
    local print_outcome="${9:-${_DEFAULT_CMD_FLAGS[6]}}"
    local strict_message="${10:-${_DEFAULT_CMD_FLAGS[7]}}"
    local no_strict_message="${11:-${_DEFAULT_CMD_FLAGS[8]}}"
    local fail_message="${12:-}"
    __safe_unset_bash_setting 'u'

    # print notice
    [ "${print_message}" = "print_message" ] && info "${message}"

    # print command
    [ "${print_cmd}" = "print_cmd" ] && info "${command}"

    # execute command and store exit code
    __cmd_exec "${command}" "${decorate_output}" "${strict}" "${print_output}" "${print_message}" "${print_status}" "${print_outcome}" "${fail_message}" "${strict_message}" "${no_strict_message}"
    local result=$?

    # pass command exit-code to caller
    return ${result}
}
