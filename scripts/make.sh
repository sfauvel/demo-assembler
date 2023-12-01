#!/usr/bin/env bash


SCRIPT_PATH="${BASH_SOURCE%/*}"
CURRENT_SCRIPT_NAME=$(basename "$BASH_SOURCE")
ORIGIN_SCRIPT_NAME=$(basename "$0")


# By default the file name used is the name of th directory
ORIGIN_PATH=$(pwd)
FILE=${FILE:=$(basename $(pwd))}
ASM_PATH=${ASM_PATH:=examples/$FILE}
TEST_PATH=${TEST_PATH:=examples/$FILE}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"


ROOT_PATH=..
BIN_PATH=${ROOT_PATH}/work/target
LIB_PATH=${ROOT_PATH}/work/lib
DEBUG_PATH=${ROOT_PATH}/work/debug


MAIN_FILENAME=${FILE}.main

PROJECT_PATH=${ROOT_PATH}/${ASM_PATH}

PYTHON=python3


function log_debug() {
    # Return 0 to log info and 1 otherwise
    return 0
}

function extract_filename() {
    local file=$(basename $1)
    local extension=$2
    echo ${file%.${extension:=*}}
}

function clean() {
    rm -rf ${BIN_PATH}
    rm -rf ${LIB_PATH}
    rm -rf ${DEBUG_PATH}

    mkdir -p ${BIN_PATH}
}

function cmd_test() {
    clean
    run_test
}

function run_test() {
  
    local param_include_paths="$include_paths"
    local param_object_files="$object_files"
    local test_filter="*"
    for f in ${ROOT_PATH}/${TEST_PATH}/${test_filter}.test.c
    do
        include_paths="$param_include_paths"
        object_files="$param_object_files"
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"
        # Generate test files
        build_test_file ${ROOT_PATH}/${TEST_PATH}/${test_name}.test.c ${BIN_PATH}/${test_name}.test.c
        
        MAIN_FILENAME=${test_name}.test
        include_paths+="${ROOT_PATH}/test ${ROOT_PATH}/examples/print "
        
        local c_file=${BIN_PATH}/${MAIN_FILENAME}.c
        object_files+=$(compile_asm $LIB_PATH ${ROOT_PATH}/${ASM_PATH}) 

        include_paths+="${PROJECT_PATH} "
        local output_program=${BIN_PATH}/${MAIN_FILENAME}.o
        compile

        ${BIN_PATH}/${test_name}.test.o
    done
}

function cmd_run() {
    clean
    run_run
}

function cmd_run_asm() {
    clean
    
    compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}
    ld $LIB_PATH/$FILE.o -o $BIN_PATH/$FILE 
    $BIN_PATH/$FILE
}

function run_run() {
    
    local c_file=${ROOT_PATH}/${TEST_PATH}/$MAIN_FILENAME.c
    object_files+=$(compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}) 

    include_paths+="${PROJECT_PATH} "
    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    compile

    ${BIN_PATH}/$MAIN_FILENAME.o
}

function cmd_debug() {
    clean
    generate_debug_asm_files
    generate_debug_c_file

    cmd_compile_run_debug
}

function compile_debug_libs() {
    # print.o and debug.o need to be compiled
    object_files+=$(compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/print)
    object_files+=$(compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/debug)
}

function cmd_compile_run_debug() {
    compile_debug_libs
    compile_and_run_debug
}

# Use this command to just load all functions
function cmd_no_run() {
    return
}

function compile_and_run_debug() {

    echo "output_program  => $output_program"
    
    DEBUG_DATA_FILE="$DEBUG_PATH/debug.data"
    MAIN_FILENAME=$MAIN_FILENAME.debug

    local c_file=${DEBUG_PATH}/$MAIN_FILENAME.c
    object_files+=$(compile_asm $LIB_PATH $DEBUG_PATH)

    include_paths+="${PROJECT_PATH} "
    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    compile

    ${output_program} $DEBUG_DATA_FILE

    $PYTHON format_debug.py $DEBUG_DATA_FILE
}


# Compile all files in [asm_path] to the output [output_path] folder.
# $1: Output path where .o will be generated.
# $2: Source path where .asm are.
function compile_asm() {
    local output_path=$1
    local asm_path=$2
    mkdir -p ${output_path}
    
    local output_files=""
    for asm_file in $asm_path/*.asm
    do
        local filename=$(extract_filename $asm_file asm)
        local output_file=${output_path}/${filename}.o
        nasm $asm_file -o ${output_file} -felf64

        output_files+=" ${output_file} "
    done
    echo "$output_files"
}

# Compile a .c file
# c_file: the c file
# object_files: .o files
# includes: paths to include
# output_program: output file
function compile() {
    
    log_debug && echo c_file: $c_file
    log_debug && echo object_files: $object_files
    log_debug && echo include_paths: $include_paths
    log_debug && echo output_program: $output_program

    includes=""
    for include_file in ${include_paths}
    do 
        includes+="-I${include_file} "
    done
    gcc -no-pie ${c_file} ${object_files} ${includes} -o ${output_program}    
}

function generate_debug_asm_files() {
    for asm_file in $PROJECT_PATH/*.asm
    do
        filename=$(extract_filename $asm_file asm)
        $PYTHON generate_debug.py $PROJECT_PATH $filename $DEBUG_PATH
    done
}


function generate_debug_c_file() {
    $PYTHON generate_debug_c_file.py $PROJECT_PATH $MAIN_FILENAME $DEBUG_PATH
}


help() {
    echo Select one of this method as parameter

    for script_file in $CURRENT_SCRIPT_NAME $ORIGIN_PATH/$ORIGIN_SCRIPT_NAME 
    do
        grep "[f]unction cmd_.*() {" "$script_file" | sed 's/function cmd_\(.*\)(.*/  - \1/g' 
    done
}

####################################################################

pushd $CURRENT_DIR > /dev/null
. ${ROOT_PATH}/test/test_generate.sh

# You can redefine one of the command in your own file:
# function custom_cmd_test() { ... }

USE_CASE=cmd_$1
CUSTOM_USE_CASE=custom_$USE_CASE
COMMIT_COUNTER=0
if [[ -z $1 || -z $(command -v $USE_CASE) ]]; then
    help
else
    if [[ -z $(command -v $CUSTOM_USE_CASE) ]]; then
        $USE_CASE "${@:2}"
    else
        $CUSTOM_USE_CASE "${@:2}"
    fi
fi

popd  > /dev/null