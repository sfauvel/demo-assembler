#!/usr/bin/env bash

export MAIN_FILENAME=simple.test
export include_paths="../../test "


CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null
