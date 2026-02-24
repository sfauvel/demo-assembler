#!/usr/bin/env bash


export include_paths="./include "
export ASM_PATH=./asm

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
../../scripts/make.sh $*
popd