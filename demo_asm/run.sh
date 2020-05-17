#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
pushd ${current_dir}/..
. run_tests.sh "*" demo_asm demo_asm
popd
