### Dependencies
###############################################################################
# depends_on: [ ]
###############################################################################

###############################################################################
#### calculate entrypoint script name
###############################################################################
# compute top-level script name
get_entrypoint_script() {
    # get last index from BASH_SOURCE list
    _bash_caller_first_index=$(( ${#BASH_SOURCE[@]} - 1 ))
    # get last value
    _bash_caller_first_path=${BASH_SOURCE[${_bash_caller_first_index}]}
    # shorten absolute path to just script name
    _bash_caller_first_name=${_bash_caller_first_path##*/}

    # return result
    echo ${_bash_caller_first_name}
}

###############################################################################
#### append script section to prefix
###############################################################################
__bf_script_section='';

get_script_section() {
    [ -n "${__bf_script_section}" ] && printf "[%s]" "${__bf_script_section}"
}

###############################################################################
#### pipefail
###############################################################################
## test if pipefail is on
__test_pipefail() {
    set -o | grep pipefail | grep -q 'on'
}

## switch between pipefail on and off
__toggle_pipefail() {
    if __test_pipefail; then
        # disable pipefail
        set +o pipefail
    else
        # enable pipefail
        set -o pipefail
    fi
}

## safely set desired state of bash pipefail
# this will save the original value in a dynamically generated variable
# the state variable is exported and can be called elsewhere
__safe_set_bash_pipefail() {
    var_name="__set_pipefail_original"

    # save pipefail status
    __test_pipefail && printf -v $var_name "0" || printf -v $var_name "1"
    export "${var_name}"

    # toggle pipefail only if it was disabled
    __test_pipefail || __toggle_pipefail
}

## safely unset desired state of bash setting
# this will check the original setting value and only unset it if
# it was not enabled
__safe_unset_bash_pipefail() {
    var_name="__set_pipefail_original"

    # toggle bash setting only if it was not enabled
    [ "${!var_name}" -eq 1 ] && __toggle_pipefail
}

###############################################################################
#### bash settings
###############################################################################
## test if bash settings are enabled (parametrized)
__test_bash_setting() {
    option="$1"
    old_setting=${-//[^${option}]/}
    if [[ -n "$old_setting" ]]; then
        return 0
    else
        return 1
    fi
}

## switch bash setting (parametrized) between on and off
__toggle_bash_setting() {
    option="$1"
    old_setting=${-//[^${option}]/}
    if [[ -n "$old_setting" ]]; then
        set +${option}
    else
        set -${option}
    fi
}

## safely set desired state of bash setting
# this will save the original value in a dynamically generated variable
# the state variable is exported and can be called elsewhere
__safe_set_bash_setting() {
    option="${1}"
    var_name="__set_${option}_original"

    # save bash setting status
    __test_bash_setting "${option}" && printf -v $var_name "0" || printf -v $var_name "1"
    export "${var_name}"

    # toggle bash setting only if it was disabled
    __test_bash_setting "${option}" || __toggle_bash_setting "${option}"
}

## safely unset desired state of bash setting
# this will check the original setting value and only unset it if
# it was not enabled
__safe_unset_bash_setting() {
    option="${1}"
    var_name="__set_${option}_original"

    # toggle bash setting only if it was not enabled
    [ "${!var_name}" -eq 1 ] && __toggle_bash_setting "${option}"
}

###############################################################################
#### color output detection and display error handling
###############################################################################
__count_colored_sequences() {
    message="${1}"

    # detect how many color reset sequences are present in the message
    echo $message | grep -o '\e\[0m' | wc -l
}

__adjust_length_to_colored_output() {
    message="${1}"
    sequence_length="${2}"
    # adjust by adding 9 characters per color sequence (works for plain colors)
    adjustment_delta="${3:-9}"

    # extract colored sequence count
    color_sequence_count="$(__count_colored_sequences "${message}")"

    # adjust sequence_length with counted multiples of the adjustment_delta
    echo "$(( ${color_sequence_count} * ${adjustment_delta} + ${sequence_length} ))"
}

###############################################################################
#### assertions
###############################################################################
## test if string is present in space-delimited string array
__assert_string_list_contains() {
    local string="${1}"
    local list_string="${2}"

    # convert string to list
    old_IFS="${IFS}"
    local list=(${list_string})
    IFS="${old_IFS}"

    # assume search fails
    local result=1
    for item in "${list[@]}"; do
        # check if string is found and set our return code to success
        echo "${item}" | grep -q "^${string}$" && result=0
    done

    # pass result
    return "${result}"
}
