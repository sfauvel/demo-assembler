#!/bin/bash

TARGET_PATH=../../work/target
function clean() {
    rm -rf $TARGET_PATH
    mkdir -p $TARGET_PATH
}
clean

nasm -felf64 asmunit.test.asm -o $TARGET_PATH/asmunit.test.o

gcc -no-pie $TARGET_PATH/asmunit.test.o -o $TARGET_PATH/asmunit.test

sleep 0.1
$TARGET_PATH/asmunit.test

nb_fails=$?

echo
if [ $nb_fails = 0 ]
then
    echo -e "\e[32mSuccess\e[0m"
else
    echo -e "\e[31mFailure\e[0m"
fi
