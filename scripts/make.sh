#!/usr/bin/env bash


SCRIPT_PATH="${BASH_SOURCE%/*}"
CURRENT_SCRIPT_NAME=$(basename "$BASH_SOURCE")
ORIGIN_SCRIPT_NAME=$(basename "$0")

source "$SCRIPT_PATH/log.sh"

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
    run_test $@
}

# It's possible to pass the test name to launch only this one.
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
        
        compile_asm $LIB_PATH ${ROOT_PATH}/${ASM_PATH}
        object_files+="$(extract_output $LIB_PATH)"

        include_paths+="${PROJECT_PATH} "
        local output_program=${BIN_PATH}/${MAIN_FILENAME}.o
        compile ${BIN_PATH}/${MAIN_FILENAME}.c ${output_program}

        execute "Execute test" \
        ${output_program} $@
    done
}

function cmd_run() {
    clean
    run_run
}

function cmd_run_asm() {
    clean
    
    local asm_path="${ROOT_PATH}/${TEST_PATH}"
    local output_path="${LIB_PATH}"
    local output_program=${BIN_PATH}/${FILE} 

    compile_and_run_asm $output_path $asm_path $output_program
}

function compile_and_run_asm() {
    local output_path="$1"
    local asm_path="$2"
    local output_program="$3"

    compile_asm ${output_path} ${asm_path}
    local object_files="$(extract_output ${output_path})"
    execute "Link" \
    ld $object_files -o ${output_program}

    ${output_program}
}

function run_run() {
    compile_asm $LIB_PATH ${ROOT_PATH}/${TEST_PATH}
    object_files+="$(extract_output $LIB_PATH)"

    include_paths+="${PROJECT_PATH} "
    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    compile ${ROOT_PATH}/${TEST_PATH}/$MAIN_FILENAME.c ${output_program}

    ${output_program}
}

function cmd_debug() {
    clean
    generate_debug_asm_files
    generate_debug_c_file

    cmd_compile_run_debug
}

function compile_debug_libs() {
    # print.o and debug.o need to be compiled
    compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/print
    compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/debug
    object_files+="$(extract_output $LIB_PATH)"
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
    
    local debug_data_file="$DEBUG_PATH/debug.data"
    MAIN_FILENAME=$MAIN_FILENAME.debug

    compile_asm $LIB_PATH $DEBUG_PATH
    object_files+="$(extract_output $LIB_PATH)"

    include_paths+="${PROJECT_PATH} "
    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    compile ${DEBUG_PATH}/$MAIN_FILENAME.c ${output_program}

    ${output_program} $debug_data_file

    execute "Run debug" \
    $PYTHON format_debug.py $debug_data_file $DEBUG_PATH
}


# Extract all files in [asm_path] to the output [output_path] folder.
# $1: Output path where .o has been generated.
function extract_output() {
    local obj_path=$1
    local obj_files=""
    for obj_file in $obj_path/*.o
    do
        obj_files+=" ${obj_file} "
    done
    echo "$obj_files"
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
        [ -f "$asm_file" ] || continue
        local filename=$(extract_filename $asm_file asm)
        local output_file=${output_path}/${filename}.o
        
        execute "Compile asm file: ${asm_file##*/}" \
        nasm $asm_file -o ${output_file} -i ${asm_path} -felf64

        output_files+=" ${output_file} "
    done

}

# Compile a .c file
# $1: the c file
# $2: output file
# object_files: .o files
# includes: paths to include
function compile() {
    
    local c_file="$1"
    local output_program="$2"
    log_debug && echo c_file: $c_file
    log_debug && echo object_files: $object_files
    log_debug && echo include_paths: $include_paths
    log_debug && echo output_program: $output_program

    includes=""
    for include_file in ${include_paths}
    do 
        includes+="-I${include_file} "
    done

    execute "Compile" \
    gcc -no-pie -z noexecstack ${c_file} ${object_files} ${includes} -o ${output_program}    
}

function generate_debug_asm_files() {
    for asm_file in $PROJECT_PATH/*.asm
    do
        filename=$(extract_filename $asm_file asm)
        execute "Generate debug asm" \
        $PYTHON generate_debug.py $PROJECT_PATH $filename $DEBUG_PATH
    done
}


function generate_debug_c_file() {
    execute "Generate debug c" \
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


execute "Move to $CURRENT_DIR" pushd $CURRENT_DIR
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
        execute "Execute command" \
        $USE_CASE "${@:2}"
    else
        execute "Execute custom command" \
        $CUSTOM_USE_CASE "${@:2}"
    fi
fi

popd  > /dev/null