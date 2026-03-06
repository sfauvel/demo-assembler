#!/usr/bin/env bash
# Execute `make.sh debug` in the folder which is the first parameter

$1/make.sh debug "${@:2}"