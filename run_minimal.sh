#!/usr/bin/env bash

# Define test file
test_path=howto
test_name=minimal

# Clean build directory
rm -rf target
mkdir target

# Compile test
gcc ${test_path}/${test_name}.test.c -o target/${test_name}.test.o

# Execute tests
./target/${test_name}.test.o