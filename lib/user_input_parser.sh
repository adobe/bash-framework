get_user_input() {
    # input vars
    __safe_set_bash_setting 'u'
    local message_question="${1}"
    local message_if_yes_default="You chose yes. Continuing..."
    local message_if_yes="${2:-${message_if_yes_default}}"
    local message_if_no_default="You chose no. Cancelling..."
    local message_if_no="${3:-${message_if_no_default}}"
    local message_confirmation_default="Proceed? ($(__add_emphasis_green 'yes')/$(__add_emphasis_red 'no'))"
    local message_confirmation="${4:-${message_confirmation_default}}"
    __safe_unset_bash_setting 'u'

    # get and parse user input
    while true; do
        info "${message_question}"
        info "${message_confirmation}"
        read -p "$(info '<<< ')" yn
        case $yn in
            [Yy]es ) info "${message_if_yes}"; break;;
            [Nn]o ) error "${message_if_no}"; exit 2;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}
