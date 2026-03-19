#!/usr/bin/env bash

export START_LABEL="write_file"

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
rm tmp/*
mkdir -p tmp
../../scripts/make.sh $*
popd
