#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"


ROOT_PATH=..
BIN_PATH=${ROOT_PATH}/work/target
LIB_PATH=${ROOT_PATH}/work/lib
DEBUG_PATH=${ROOT_PATH}/work/debug


MAIN_FILENAME=${FILE}.main
DEBUG_FILENAME=${FILE}.debug

PROJECT_PATH=${ROOT_PATH}/${ASM_PATH}

PYTHON=python3

function clean() {
    rm -rf ${BIN_PATH}
    rm -rf ${LIB_PATH}
    rm -rf ${DEBUG_PATH}

    mkdir -p ${BIN_PATH}
}

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
    local include_project_path=${PROJECT_PATH}

    local test_filter="*"
    for f in ${ROOT_PATH}/${TEST_PATH}/${test_filter}.test.c
    do
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"
        # Generate test files
        build_test_file ${ROOT_PATH}/${TEST_PATH}/${test_name}.test.c ${BIN_PATH}/${test_name}.test.c
      
        local asm_files=$(compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}) 
        gcc -no-pie ${BIN_PATH}/${test_name}.test.c ${asm_files} -I${include_project_path} -I${include_test_path} -I${include_print_path} -o ${BIN_PATH}/${test_name}.test.o
 
        ${BIN_PATH}/${test_name}.test.o
    done
}

function cmd_run() {
    local include_project_path=${PROJECT_PATH}
    object_files=$(compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}) 

    gcc -I. -no-pie ${ROOT_PATH}/${TEST_PATH}/$MAIN_FILENAME.c $object_files -I${include_project_path} -o ${BIN_PATH}/$MAIN_FILENAME.o
    ${BIN_PATH}/$MAIN_FILENAME.o
}


function compile_lib() {
    local lib=$1
    if [[ ! -f $LIB_PATH/$lib.o ]]; then
        echo "Recompiled $lib"
        compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/$lib
    fi
}

function cmd_debug() {

    #debug_file_to_run=${1:-"$DEBUG_FILENAME"}
    debug_file_to_run=$MAIN_FILENAME.debug
    local include_project_path=${PROJECT_PATH}

    for filepath in $PROJECT_PATH/*.asm
    do
        filename=${filepath##*/}
        filename=${filename%%.*}
        $PYTHON generate_debug.py $PROJECT_PATH $filename $DEBUG_PATH
    done

    # print.o and debug.o need to be compiled
    object_files="$LIB_PATH/print.o $LIB_PATH/debug.o "
    compile_lib print
    compile_lib debug

    generate_debug_file

    DEBUG_DATA_FILE="$DEBUG_PATH/debug.data"
    object_files+=$(compile_asm $LIB_PATH $DEBUG_PATH) 
    #gcc -I. -no-pie ${ROOT_PATH}/${TEST_PATH}/$debug_file_to_run.c $object_files -o ${BIN_PATH}/$debug_file_to_run.o    
    gcc -I. -no-pie ${DEBUG_PATH}/$debug_file_to_run.c $object_files -I${include_project_path} -o ${BIN_PATH}/$debug_file_to_run.o    
    ${BIN_PATH}/$debug_file_to_run.o $DEBUG_DATA_FILE

    $PYTHON format_debug.py $DEBUG_DATA_FILE
}

function generate_debug_file() {
    $PYTHON generate_debug_c_file.py $PROJECT_PATH $MAIN_FILENAME $DEBUG_PATH
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
    clean
    $USE_CASE "${@:2}"
fi
popd