#!/usr/bin/env bash


export include_paths="./include "
export ASM_PATH=./asm

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER" > /dev/null
../../scripts/make.sh $*
popd > /dev/null