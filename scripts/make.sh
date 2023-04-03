#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"


ROOT_PATH=..
BIN_PATH=${ROOT_PATH}/target
LIB_PATH=${ROOT_PATH}/lib
DEBUG_PATH=${ROOT_PATH}/debug


MAIN_FILENAME=${FILE}.main

PROJECT_PATH=${ROOT_PATH}/${ASM_PATH}

PYTHON=python3

function compile_asm() {
    local lib_path=$1
    local asm_path=$2
    mkdir -p ${lib_path}
    
    for filepath in $asm_path/*.asm
    do
        filename=${filepath##*/}
        filename=${filename%%.*}
        output_file=${lib_path}/${filename}.o
        nasm $filepath -o ${output_file} -felf64

        echo "${output_file}"
    done

}

function cmd_test() {
    local include_test_path=${ROOT_PATH}/test
    local include_print_path=${ROOT_PATH}/examples/print

    local test_filter="*"
    for f in ${ROOT_PATH}/${TEST_PATH}/${test_filter}.test.c
    do
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"
        # Generate test files
        build_test_file ${ROOT_PATH}/${TEST_PATH}/${test_name}.test.c ${ROOT_PATH}/target/${test_name}.test.c
      
        local asm_files=$(compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}) 
        gcc -no-pie ${ROOT_PATH}/target/${test_name}.test.c ${asm_files} -I${include_test_path} -I${include_print_path} -o ${ROOT_PATH}/target/${test_name}.test.o
 
        ${ROOT_PATH}/target/${test_name}.test.o
    done
}

function cmd_run() {
    object_files=$(compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}) 

    gcc -I. -no-pie ${ROOT_PATH}/${TEST_PATH}/$MAIN_FILENAME.c $object_files -o ${BIN_PATH}/$MAIN_FILENAME.o
    ${BIN_PATH}/$MAIN_FILENAME.o
}


function cmd_debug() {


    for filepath in $PROJECT_PATH/*.asm
    do
        filename=${filepath##*/}
        filename=${filename%%.*}
        $PYTHON generate_debug.py $PROJECT_PATH $filename $DEBUG_PATH
    done

    # print.o and debug.o need to be compiled
    object_files="$LIB_PATH/print.o $LIB_PATH/debug.o "
    if [[ ! -f $LIB_PATH/print.o ]]; then
        echo "Recompiled print.o"
        compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/print
        #pushd ${ROOT_PATH}/print; ./make_print.sh; popd
    fi
    if [[ ! -f $LIB_PATH/debug.o ]]; then
        echo "Recompiled debug.o"
        compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/debug
        #pushd ${ROOT_PATH}/debug; ./make_debug.sh; popd
    fi

    object_files+=$(compile_asm $LIB_PATH $DEBUG_PATH) 
    gcc -I. -no-pie ${ROOT_PATH}/${TEST_PATH}/$MAIN_FILENAME.c $object_files -o ${BIN_PATH}/$MAIN_FILENAME.o    
    ${BIN_PATH}/$MAIN_FILENAME.o

    $PYTHON format_debug.py
}



help() {
    echo Select one of this method as parameter
    
    CURRENT_SCRIPT=`basename "$0"`
    grep "[f]unction cmd_.*() {" "$CURRENT_SCRIPT" | sed 's/function cmd_\(.*\)(.*/  - \1/g' 
}


pushd $CURRENT_DIR
. ${ROOT_PATH}/test/test_generate.sh

USE_CASE=cmd_$1
COMMIT_COUNTER=0
if [[ -z $1 || -z $(command -v $USE_CASE) ]]; then
    help
else
    mkdir -p ${BIN_PATH}
    $USE_CASE
fi
popd