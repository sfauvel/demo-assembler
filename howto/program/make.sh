#!/usr/bin/env bash

# Use make.sh run_asm

export MAIN_FILENAME=minimal.test

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null
