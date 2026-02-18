#!/usr/bin/env bash

# Define test file
test_path=.
test_name=minimal
target=../target

# Clean build directory
rm -rf ${target}
mkdir ${target}

# Compile test
gcc ${test_path}/${test_name}.test.c -o ${target}/${test_name}.test.o

# Execute tests
./${target}/${test_name}.test.o