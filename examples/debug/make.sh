#!/usr/bin/env bash


export MAIN_FILENAME=debug.main
export include_paths="../print "


CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"

function custom_cmd_test() {
    clean
    compile_asm $LIB_PATH ../print
    run_test
}
export -f custom_cmd_test

function custom_cmd_run() {
    clean
    compile_asm $LIB_PATH ../print
    run_run
}
export -f custom_cmd_run

../../scripts/make.sh $*
popd
