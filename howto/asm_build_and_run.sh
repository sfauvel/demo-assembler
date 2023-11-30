#!/usr/bin/env bash

# Build an .asm fiel and run it

asm_path=.
target=../work/target

function build_and_run() {
    asm_file_name=$1

    # Clean build directory
    rm -rf ${target}
    mkdir ${target}

    # Compile asm
    nasm -felf64 ${asm_path}/${asm_file_name}.asm -o ${target}/${asm_file_name}.o

    # Link it
    ld ${target}/${asm_file_name}.o -o ${target}/${asm_file_name}

    # Execute tests
    ./${target}/${asm_file_name}
}

if [[ -z $1 ]]; then
    echo "Please provide the name of one of the asm files:"    
    for file in $(ls *.asm)
    do
        echo "  - $file"
    done
else
    NAME=${1%.asm}
    if [ -f "$NAME.asm" ]; then
        build_and_run $NAME
    else
        echo "File $1 does not exist or not ends with .asm"
    fi
fi