#!/usr/bin/env bash

GREY="\033[0;30m"
GREEN="\033[0;32m"
WHITE="\033[0;37m"
NO_COLOR="\033[0m"

function execute() {
    local label=$1
    local cmd="${@:2}"
    echo -e "\n===  ${WHITE}${label}${NO_COLOR}  ===\n   ${GREEN}${cmd}${NO_COLOR}"
    eval $cmd
}

function compileAndRunTest() {

    local test_name=$1
    local asm_path=$2
    local test_path=$3

    execute "Compile asm" nasm -felf64 ${asm_path}/${test_name}.asm -o target/${test_name}.asm.o
  
    local include_path=./test
    execute "Compile test" gcc ${test_path}/${test_name}.test.c -I${include_path} target/${test_name}.asm.o -o target/${test_name}.test.o

    execute "Launch ${test_name}.test" ./target/${test_name}.test.o
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


