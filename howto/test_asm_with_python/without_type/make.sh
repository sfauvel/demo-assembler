#!/usr/bin/env bash

function custom_cmd_test() {
    cmd_pytest $@
}
export -f custom_cmd_test

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../../scripts/make.sh $*
popd > /dev/null
