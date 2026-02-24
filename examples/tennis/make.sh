#!/usr/bin/env bash

export include_paths=". "

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
../../scripts/make.sh $*
popd