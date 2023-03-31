#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"


relative_path=..
BIN_PATH=${relative_path}/target
LIB_PATH=${relative_path}/lib
DEBUG_PATH=${relative_path}/debug


MAIN_FILENAME=${FILE}.main

PROJECT_PATH=${relative_path}/${ASM_PATH}

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
    current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
    pushd ${relative_path}
    . run_tests.sh "${FILE}" ${TEST_PATH} ${TEST_PATH}
    popd
}

function cmd_test_bis() {
    local include_test_path=${relative_path}/test
    local include_print_path=${relative_path}/examples/print

    local test_filter="*"
    for f in ${relative_path}/${TEST_PATH}/${test_filter}.test.c
    do
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"
        # Generate test files
        build_test_file ${relative_path}/${TEST_PATH}/${test_name}.test.c ${relative_path}/target/${test_name}.test.c
      
        local asm_files=$(compile_asm $LIB_PATH ${relative_path}/${TEST_PATH}) 
        gcc -no-pie ${relative_path}/target/${test_name}.test.c ${asm_files} -I${include_test_path} -I${include_print_path} -o ${relative_path}/target/${test_name}.test.o
 
        ${relative_path}/target/${test_name}.test.o
    done
}

function cmd_run() {
    object_files=$(compile_asm $LIB_PATH ${relative_path}/${TEST_PATH}) 

    gcc -I. -no-pie ${relative_path}/${TEST_PATH}/$MAIN_FILENAME.c $object_files -o ${BIN_PATH}/$MAIN_FILENAME.o
    ${BIN_PATH}/$MAIN_FILENAME.o
}

function debug_asm() {
    local lib_path=$1
    local asm_path=$2
    echo -e "Lib $lib_path \n"
    echo -e "Asm $asm_path ___ "
    mkdir -p ${lib_path}
    files=""
    for filepath in $asm_path/*.asm
    do
        echo $filepath
        filename=${filepath##*/}
        filename=${filename%%.*}
        output_file=${lib_path}/${filename}.o
        files="${files} ${output_file}"
        echo " nasm $filepath -o ${output_file} -felf64"
        nasm $filepath -o ${output_file} -felf64
    done
    echo $files
}


function cmd_debug() {


    for filepath in $PROJECT_PATH/*.asm
    do
        filename=${filepath##*/}
        filename=${filename%%.*}
        $PYTHON debug.py $PROJECT_PATH $filename $DEBUG_PATH
    done

    object_files="$LIB_PATH/print.o $LIB_PATH/debug.o "
    if [[ ! -f $LIB_PATH/print.o ]]; then
        echo "Recompiled print.o"
        compile_asm ${LIB_PATH} ${relative_path}/examples/print
        #pushd ${relative_path}/print; ./make_print.sh; popd
    fi
    if [[ ! -f $LIB_PATH/debug.o ]]; then
        echo "Recompiled debug.o"
        compile_asm ${LIB_PATH} ${relative_path}/examples/debug
        #pushd ${relative_path}/debug; ./make_debug.sh; popd
    fi

    # print.o and debug.o need to be compiled
    object_files+=$(compile_asm $LIB_PATH $DEBUG_PATH) 
     
    echo $object_files 
    gcc -I. -no-pie ${relative_path}/${TEST_PATH}/$MAIN_FILENAME.c $object_files -o ${BIN_PATH}/$MAIN_FILENAME.o    
    echo "${BIN_PATH}/$MAIN_FILENAME.o"
    ${BIN_PATH}/$MAIN_FILENAME.o
}



help() {
    echo Select one of this method as parameter
    
    CURRENT_SCRIPT=`basename "$0"`
    grep "[f]unction cmd_.*() {" "$CURRENT_SCRIPT" | sed 's/function cmd_\(.*\)(.*/  - \1/g' 
}


pushd $CURRENT_DIR
. ${relative_path}/test/test_generate.sh

USE_CASE=cmd_$1
COMMIT_COUNTER=0
if [[ -z $1 || -z $(command -v $USE_CASE) ]]; then
    help
else
    mkdir -p ${BIN_PATH}
    $USE_CASE
fi
popd