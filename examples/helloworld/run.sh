#!/bin/bash

nasm -felf64 asmunit.test.asm -o target/asmunit.test.o

gcc target/asmunit.test.o -o  target/asmunit.test

./target/asmunit.test

nb_fails=$?

echo
if [ $nb_fails = 0 ]
then
    echo -e "\e[32mSuccess\e[0m"
else
    echo -e "\e[31mFailure\e[0m"
fi
