#!/usr/bin/env bash

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../../scripts/make.sh $*
popd > /dev/null
