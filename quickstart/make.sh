#!/usr/bin/env bash

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
export ASM_PATH=../quickstart
export TEST_PATH=../quickstart
../scripts/make.sh $*
popd
