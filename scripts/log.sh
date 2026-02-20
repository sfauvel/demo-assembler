#!/bin/bash

REY="\033[0;30m"
GREEN="\033[0;32m"
WHITE="\033[0;37m"
NO_COLOR="\033[0m"

# You can redefine thos function in your script to set log.
function log_debug() {
    # Return 0 to log info and 1 otherwise
    return 0
}

# This function log the command before executing it
# Usage in multiline (more readable):
#   execute "List files " \
#   ls my_dir
# or in one line:
#   execute "List files " ls my_dir
function execute() {
    local label=$1
    local cmd="${@:2}"
    log_debug && echo -e "${GREEN}===  ${label}  ===${NO_COLOR}\n   ${WHITE}${cmd}${NO_COLOR}\n"
    eval $cmd
}