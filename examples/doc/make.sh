#!/usr/bin/env bash

function custom_cmd_test() {
    clean
    generate_debug_asm_files

    compile_debug_libs

    ASM_PATH=/work/debug
    # DEBUG_PATH contains ${ROOT_PATH}/work/debug maybe ASM_PATH should include ROOT_PATH
    run_test
}

. ../../scripts/make.sh $*
