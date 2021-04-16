#!/bin/bash

nasm -felf64 asmunit.test.asm -o target/asmunit.test.o

gcc target/asmunit.test.o -o  target/asmunit.test

./target/asmunit.test

echo $?