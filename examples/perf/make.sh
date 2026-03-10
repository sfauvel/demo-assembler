#!/usr/bin/env bash

export MAIN_FILENAME=perf.main
export include_paths="../print "

function custom_cmd_test() {
    cmd_run $@
}
export -f custom_cmd_test

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null
