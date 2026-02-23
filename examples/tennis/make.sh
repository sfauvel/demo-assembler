#!/usr/bin/env bash

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
../../scripts/make.sh $*
popd