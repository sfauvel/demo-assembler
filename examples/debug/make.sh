#!/usr/bin/env bash

function custom_cmd_test() {
    clean
    object_files=$(compile_asm $LIB_PATH $ROOT_PATH/examples/print)
    run_test
}

function custom_cmd_run() {
    clean
    object_files=$(compile_asm $LIB_PATH $ROOT_PATH/examples/print)
    run_run
}

. ../../scripts/make.sh $*
