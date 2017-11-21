# function user_input {

#     while true; do
#         info ""
#         printf "\e[30m[packer-tool]\e[0m %s\n" "Will run: ${cmd}"
#         info "Proceed? (yes/no)"
#         read -p "$(printf '\e[30m[packer-tool]\e[0m %s' '<<< ')" yn
#         case $yn in
#             [Yy]* ) info "Building AMI..."; break;;
#             [Nn]* ) exit 2;;
#             * ) echo "Please answer yes or no.";;
#         esac
#     done

# }
