#!/bin/bash
# This script compile the assembly code, create a shared library,
# run the main C program that uses it and run the Python tests.
# ./make.sh; while true; do inotifywait -q -r -e create,modify,delete .; ./make.sh; date; done;
# Readings:
# https://docs.python.org/3/library/ctypes.html
# https://realpython.com/python-bindings-overview/

LIB_NAME=tennis
PROG_NAME=${LIB_NAME}.main
SOURCE_DIR=..
INCLUDE_DIR=..
BUILD_DIR=target

mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}

echo "Clean environment..."
rm -f *.o *.so ${PROG_NAME}

echo "Compiling assembly code..."
nasm -felf64 ${SOURCE_DIR}/${LIB_NAME}.asm -o ${LIB_NAME}.o

echo "Create the shared library..."
ld -shared ${LIB_NAME}.o -o ${LIB_NAME}.so

echo "Compiling the main C program..."
# # -z noexecstack to avoid a warning
gcc -z noexecstack ${SOURCE_DIR}/${PROG_NAME}.c ${LIB_NAME}.o  -I${INCLUDE_DIR} -o ${PROG_NAME}

popd

echo "Execute the main program..."
${BUILD_DIR}/${LIB_NAME}.main

echo "Run tests..."
pytest -vv -s

