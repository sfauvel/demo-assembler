#!/bin/bash
# This script compile the assembly code, create a shared library,
# run the main C program that uses it and run the Python tests.
# ./make.sh; while true; do inotifywait -q -r -e create,modify,delete .; ./make.sh; date; done;
# Readings:
# https://docs.python.org/3/library/ctypes.html
# https://realpython.com/python-bindings-overview/


source ../../scripts/log.sh

LIB_NAME=tennis
PROG_NAME=${LIB_NAME}.main
SOURCE_DIR=..
INCLUDE_DIR=..
BUILD_DIR=target

execute "Create working dir" \
mkdir -p ${BUILD_DIR}
execute "Move to the working dir" \
pushd ${BUILD_DIR}

execute "Clean environment" \
rm -f *.o *.so ${PROG_NAME}

execute "Compiling assembly code" \
nasm -felf64 ${SOURCE_DIR}/${LIB_NAME}.asm -o ${LIB_NAME}.o

execute "Create the shared library..." \
ld -shared ${LIB_NAME}.o -o ${LIB_NAME}.so

# -z noexecstack to avoid a warning
execute "Compiling the main C program..." \
gcc -z noexecstack ${SOURCE_DIR}/${PROG_NAME}.c ${LIB_NAME}.o  -I${INCLUDE_DIR} -o ${PROG_NAME}

popd

execute "Execute the main program" \
${BUILD_DIR}/${LIB_NAME}.main

execute "Run tests" \
pytest -vv -s

