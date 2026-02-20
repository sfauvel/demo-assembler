#!/usr/bin/env bash

source ../scripts/log.sh


function compileAndRunTest() {

    local test_name=$1
    local asm_path=$2
    local test_path=$3

    execute "Compile asm" \
    nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o
  
    local include_path=../test
    execute "Compile test" \
    gcc ${test_path}/${test_name}.test.c -z noexecstack -I${include_path} target/${test_name}.asm.o -o target/${test_name}.test.o

    execute "Launch ${test_name}.test" \
    ./target/${test_name}.test.o
}

function clean() {
    rm -rf target
    mkdir target
}

test=maxofthree
asm_path=.
test_path=.

clean
compileAndRunTest $test $asm_path $test_path


