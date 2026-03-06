#!/usr/bin/env bash

# Use make.sh run

export MAIN_FILENAME=hello

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null
