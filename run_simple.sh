#!/usr/bin/env bash

# Define test file
test_path=howto
test_name=simple

# Clean build directory
rm -rf target
mkdir target

# Load functions to generate test
. test/test_generate.sh

# Generate test file
build_test_file ${test_path}/${test_name}.test.c target/${test_name}.test.c

# Compile test
include_path=./test
gcc ./target/${test_name}.test.c -I${include_path} -o target/${test_name}.test.o

# Execute tests
./target/${test_name}.test.o