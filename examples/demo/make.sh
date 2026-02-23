#!/usr/bin/env bash


export include_paths="../examples/demo/include "
export ASM_PATH=examples/demo/asm

CURRENT_FILE_FOLDER="${0%/*}"
pushd "$CURRENT_FILE_FOLDER"
../../scripts/make.sh $*
popd