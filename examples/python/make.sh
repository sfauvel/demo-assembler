#!/bin/bash
# This script compile the assembly code, create a shared library,
# run the main C program that uses it and run the Python tests.
# ./make.sh; while true; do inotifywait -q -r -e create,modify,delete .; ./make.sh; echo "Last run: $(date +%H:%m:%S)"; done;
# Readings:
# https://docs.python.org/3/library/ctypes.html
# https://realpython.com/python-bindings-overview/

LIB_NAME=lib
PROG_NAME=prog.main
SOURCE_DIR=..
BUILD_DIR=target

function build() {
    mkdir -p ${BUILD_DIR}
    pushd ${BUILD_DIR}

    echo "Clean environment..."
    rm -f *.o *.so ${PROG_NAME}

    echo "Compiling assembly code..."
    nasm -felf64 ${SOURCE_DIR}/${LIB_NAME}.asm -o ${LIB_NAME}.o

    echo "Create the shared library..."
    ld -shared ${LIB_NAME}.o -o ${LIB_NAME}.so
    popd
}

function check() {
    echo "Run MyPy..."
    mypy . --strict
    if [ $? -ne 0 ]; then
        echo "MyPy checks failed!"
        exit 1
    fi
}

function run_prog() {
    echo "Run program..."
    python prog.py
}

function run_tests() {
    echo "Run tests..."
    pytest -vv
}

build
check
run_prog
run_tests

