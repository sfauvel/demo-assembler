#!/usr/bin/env bash

# There is no test. We just run the program.
function custom_cmd_test() {
    cmd_run_asm
}
export -f custom_cmd_test

function custom_cmd_run() {
    cmd_run_asm
}
export -f custom_cmd_run

function custom_cmd_debug() {
    cmd_debug_asm
}
export -f custom_cmd_debug

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null