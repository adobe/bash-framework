# set critical internal variables
export __bf_root_dir=$(cd ${BASH_SOURCE[0]%/*}/.. && pwd -P)
export __bf_lib_dir="${__bf_root_dir}/lib"

# import low-level libs
source "${__bf_lib_dir}/base_utils.sh"
source "${__bf_lib_dir}/message_printer.sh"

# import independent module libs
source "${__bf_lib_dir}/cmd_status.sh"
source "${__bf_lib_dir}/user_input_validate.sh"
