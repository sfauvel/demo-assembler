#!/usr/bin/env bash

export include_paths=". "

function custom_cmd_test() {
    clean
    # We generate debug info to get execution information to display in documentation.
    generate_debug_asm_files

    compile_debug_libs

    ASM_PATH=/work/debug
    # DEBUG_PATH contains ${ROOT_PATH}/work/debug maybe ASM_PATH should include ROOT_PATH
    run_test
    mv ${ROOT_PATH}/work/target/*.adoc ${ROOT_PATH}/examples/doc/docs
}

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
../../scripts/make.sh $*
popd
