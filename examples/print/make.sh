#!/usr/bin/env bash

export include_paths=". "

#function custom_cmd_test() {
#    clean
#    compile_asm $LIB_PATH ../print
#    rm $LIB_PATH/print.main.o
#    run_test
#}
#export -f custom_cmd_test


CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
../../scripts/make.sh $*
popd
