#!/usr/bin/env bash

function compileAndRunTest() {
echo Before:
ls target
echo -----
    test_name=$1
    asm_path=$2
    test_path=$3
echo $test_name
echo $asm_path
echo $test_path
    # Compile asm
    echo "nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o"
    nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o

    ls target
    # Compile test
    echo "gcc ${test_path}/${test_name}.test.c target/${test_name}.asm.o -o target/${test_name}.test.o"
    gcc ${test_path}/${test_name}.test.c target/${test_name}.asm.o -o target/${test_name}.test.o

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


