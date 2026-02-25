#!/bin/bash

REY="\033[0;30m"
GREEN="\033[0;32m"
WHITE="\033[0;37m"
NO_COLOR="\033[0m"


# You can redefine this variable in your script to set log level.
LOG_DEBUG=${LOG_DEBUG:=0}
SCRIPT_RECORD=${SCRIPT_RECORD:=tmp.sh}


function log_debug() {
    # Return 0 to log info and 1 otherwise
    if [ "$LOG_DEBUG" -eq "1" ]; then
        echo -e "$1"
    fi
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
    log_debug "${GREEN}===  ${label}  ===${NO_COLOR}\n   ${WHITE}${cmd}${NO_COLOR}\n"
    echo $cmd >> "$SCRIPT_RECORD"
    eval $cmd
}