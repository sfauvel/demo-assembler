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

function create_and_run_main() {
    pushd ${BUILD_DIR}
    echo "Compiling the main C program..."
    # -z noexecstack to avoid a warning
    gcc -z noexecstack ${SOURCE_DIR}/${PROG_NAME}.c ${LIB_NAME}.o -o ${PROG_NAME}

    echo "Execute the main program..."
    ./${PROG_NAME}
    popd
}


function run_tests() {
    echo "Run tests..."
    pytest -vv
}

build
create_and_run_main
run_tests

