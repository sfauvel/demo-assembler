#!/usr/bin/env bash


function generateAndRunTest() {

    test_name=$1
    asm_path=$2
    test_path=$3
    
    rm -rf target
    mkdir target

    # Generate test file
    build_test_file ${test_path}/${test_name}.test.c target/${test_name}.test.c

    # Compile asm
    nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o
    # Compile test
    gcc ./target/${test_name}.test.c target/${test_name}.asm.o -o target/${test_name}.test.o

    echo "=================="
    echo "Run ${test_name}.test"
    echo "------------------"
    ./target/${test_name}.test.o
}


. test/test_generate.sh

test=maxofthree
asm_path=quickstart
test_path=quickstart
generateAndRunTest $test $asm_path $test_path