#!/usr/bin/env bash

export FILE="debug"
export ASM_PATH=examples/debug
export TEST_PATH=examples/debug

function custom_cmd_test() {
    clean
    compile_lib print
    object_files="$LIB_PATH/print.o "
    run_test
}

function custom_cmd_run() {
    clean
    compile_lib print
    object_files="$LIB_PATH/print.o "
    run_run
}

function custom_help() {
    help
    
    pushd $CUSTOM_CURRENT_PATH  > /dev/null

    CURRENT_SCRIPT=`basename "$0"`
    grep "[f]unction cmd_.*() {" "$CURRENT_SCRIPT" | sed 's/function cmd_\(.*\)(.*/  - \1/g' 

    popd > /dev/null
}

CUSTOM_CURRENT_PATH=$(pwd)

pushd ../../scripts > /dev/null
. ./make.sh no_run

USE_CASE=cmd_$1
CUSTOM_USE_CASE=custom_$USE_CASE
COMMIT_COUNTER=0
if [[ -z $1 || -z $(command -v $USE_CASE) ]]; then
    custom_help
else
    if [[ -z $(command -v $CUSTOM_USE_CASE) ]]; then
        $USE_CASE "${@:2}"
    else
        $CUSTOM_USE_CASE "${@:2}"
    fi
fi

popd > /dev/null