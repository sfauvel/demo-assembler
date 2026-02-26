#!/usr/bin/env bash

export MAIN_FILENAME=minimal.test
export include_paths="../../test "

function custom_cmd_test() {
    # Redirect `test` to run because a main fonction is define in test.c
    cmd_run
}
export -f custom_cmd_test

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null
