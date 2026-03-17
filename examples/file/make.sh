#!/usr/bin/env bash

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
rm tmp/*
mkdir -p tmp
../../scripts/make.sh $*
popd
