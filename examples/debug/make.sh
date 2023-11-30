#!/usr/bin/env bash

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

. ../../scripts/make.sh $*
