#!/usr/bin/env bash

# Execute `make.sh test` in the folder which is the first parameter

$1/make.sh test "${@:2}"