#!/usr/bin/env bash

export include_paths=". "

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null