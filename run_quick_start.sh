#!/usr/bin/env bash

function compileAndRunTest() {

    test_name=$1
    asm_path=$2
    test_path=$3

    # Compile asm
    local nasm_cmd="nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o"
    echo $nasm_cmd
    eval $nasm_cmd
  
    # Compile test

    gcc_cmd="gcc ${test_path}/${test_name}.test.c target/${test_name}.asm.o -o target/${test_name}.test.o"
    echo $gcc_cmd
    eval $gcc_cmd
    
    echo "=================="
    echo "Run ${test_name}.test"
    echo "------------------"
    ./target/${test_name}.test.o
}

function clean() {
    rm -rf target
    mkdir target
}

test=maxofthree
asm_path=quickstart
test_path=quickstart

clean
compileAndRunTest $test $asm_path $test_path


