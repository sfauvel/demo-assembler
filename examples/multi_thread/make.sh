#!/usr/bin/env bash

export MAIN_FILENAME=main

function custom_cmd_test() {
    cmd_run
}
export -f custom_cmd_test

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null