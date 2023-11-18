#!/usr/bin/env bash

# Define test file
test_path=howto
test_name=hello

# Clean build directory
rm -rf target
mkdir target

# Compile asm
nasm -felf64 ${test_path}/${test_name}.asm -o target/${test_name}.o

# Link it
ld target/${test_name}.o -o target/${test_name}

# Execute tests
./target/${test_name}

