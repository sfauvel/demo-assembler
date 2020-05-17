#!/usr/bin/env bash

function generateAndRunTests() {

    local test_filter=$1
    local asm_path=$2
    local test_path=$3
    
    rm -rf target
    mkdir target
    
    for f in ${test_path}/${test_filter}.test.c
    do
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"

        # Generate test files         
        build_test_file ${test_path}/${test_name}.test.c target/${test_name}.test.c
    done

    compileAndRunAllTests "$test_filter" "$asm_path" target
}

function compileAndRunAllTests() {
    
    local test_filter=$1
    local asm_path=$2
    local test_path=$3   
   
    # Compile asm
    compileAsmFiles "$asm_path"

    for f in ${test_path}/${test_filter}.test.c
    do
        filename="$(basename -- $f)"
        name="${filename%.test.c}"
        
        compileAndRunOneTest "$name" "$test_path"
    done
}

function compileAsmFiles() {
    local asm_path=$1

    echo =================
    echo Compile ASM files:
    echo -----------------

    # Compile asm
    for f in ${asm_path}/*.asm
    do
        filename="$(basename -- $f)"
        name="${filename%.asm}"
        
        echo Compile $f
        nasm -felf64 ${asm_path}/${name}.asm -o target/${name}.asm.o
    done
}

function compileAndRunOneTest() {

    local test_name=$1
    local test_path=$2

    local asm_files=$(ls target/*.asm.o)
    local include_path=./test

    # Compile
    # -no-pie to avoid  relocation R_X86_64_32S against `.bss' can not be used when making a PIE object; recompile with -fPIC
    gcc -no-pie ${test_path}/${test_name}.test.c ${asm_files} -I${include_path} -o target/${test_name}.test.o
    
    echo "=================="
    echo "Run ${test_name}.test"
    echo "------------------"
    ./target/${test_name}.test.o
}

function clean() {
    rm -rf target
    mkdir target
}

if [[ -z $1 ]]; then
    test="*"
else
    test=$1    
fi

if [[ -z $2 ]]; then
    asm_path="."
else
    asm_path=$2    
fi

if [[ -z $3 ]]; then
    test_path="."
else
    test_path=$3   
fi

echo Test filter: "$test"
echo Asm path: "$asm_path"
echo Test path: "$test_path"

clean
. test/test_generate.sh

generateAndRunTests "$test" "$asm_path" "$test_path"
