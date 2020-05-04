#!/usr/bin/env bash

function compileAndRunTest() {

    test_name=$1
    asm_path=$2
    test_path=$3

    # Compile asm
    nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o
    # Compile test
    gcc ${test_path}/${test_name}.test.c target/${test_name}.asm.o -o target/${test_name}.test.o

    echo "=================="
    echo "Run ${test_name}.test"
    echo "------------------"
    ./target/${test_name}.test.o
}


function generateAndRunTest() {

    test_name=$1
    asm_path=$2
    test_path=$3
    
    rm -rf target
    mkdir target

    # Generate test file
    build_test_file ${test_path}/${test_name}.test.c target/${test_name}.test.c

    compileAndRunTest $test_name $asm_path target
}

function clean() {
    rm -rf target
    mkdir target
}


test=tennis
asm_path=tennis
test_path=tennis

clean
. test/test_generate.sh
generateAndRunTest $test $asm_path $test_path