#!/usr/bin/env bash

# This script is executing from the sub-project folder.
# 
# We can define some variables to customize compilation
# include_paths: Folder add as included paths
# ASM_PATH: PAth where are .asm files
# TEST_PATH: Path where are test.c files
# MAIN_FILENAME: Name of the file containg `main` without extension. Default value is `[FOLDER NAME].main`
#
# It's possible to redefine a command with the prefix `custom` and call `export``:
#
# function custom_cmd_test() {
#     echo "My custom test"
# }
# export -f custom_cmd_test
#
# You can activate debug log setting LOG_DEBUG variable(0 = off, 1 = on)
# export LOG_DEBUG=0

# Paths fix in in the global project
SCRIPT_PATH="${BASH_SOURCE%/*}"
CURRENT_SCRIPT_NAME=$(basename "$BASH_SOURCE")
ORIGIN_SCRIPT_NAME=$(basename "$0")

ROOT_PATH=$(realpath --relative-to=. "${SCRIPT_PATH}/..")
TEST_TOOLS_PATH="${ROOT_PATH}/test"

BIN_PATH=${ROOT_PATH}/work/target
LIB_PATH=${ROOT_PATH}/work/lib
DEBUG_PATH=${ROOT_PATH}/work/debug
SCRIPT_RECORD=${ROOT_PATH}/work/tmp.sh
chmod u+x "$SCRIPT_RECORD"

# Paths relative to the project
# By default the file name used is the name of the directory
ABSOLUTE_PROJECT_PATH=$(pwd)
FILE=${FILE:=$(basename $(pwd))}
ASM_PATH=${ASM_PATH:=.}
TEST_PATH=${TEST_PATH:=.}

if [[ -z "$MAIN_FILENAME" ]]; then
    MAIN_FILENAME=${FILE}.main
fi
PROJECT_PATH=.

# Constants
PYTHON=python3

#####

function show_variables() {
    log_debug "===  Variables  ==="
    log_debug "   ABSOLUTE_PROJECT_PATH=$ABSOLUTE_PROJECT_PATH"
    log_debug "   SCRIPT_PATH=$SCRIPT_PATH"
    log_debug "   CURRENT_SCRIPT_NAME=$CURRENT_SCRIPT_NAME"
    log_debug "   ORIGIN_SCRIPT_NAME=$ORIGIN_SCRIPT_NAME"
    log_debug "   FILE=$FILE"
    log_debug "   ASM_PATH=$ASM_PATH"
    log_debug "   TEST_PATH=$TEST_PATH"
    log_debug "   ROOT_PATH=$ROOT_PATH"
    log_debug "   BIN_PATH=$BIN_PATH"
    log_debug "   LIB_PATH=$LIB_PATH"
    log_debug "   DEBUG_PATH=$DEBUG_PATH"
    log_debug "   MAIN_FILENAME=$MAIN_FILENAME"
    log_debug "   PROJECT_PATH=$PROJECT_PATH"
    log_debug "   SCRIPT_PATH=$SCRIPT_PATH"
    log_debug "   TEST_TOOLS_PATH=$TEST_TOOLS_PATH"
    log_debug "   PYTHON=$PYTHON"
}

### Commands

function cmd_test() {
    clean
    run_test $@
}


function cmd_run() {
    clean
    run_run
}

function cmd_debug() {
    clean
    generate_debug_asm_files
    generate_debug_c_file

    cmd_compile_run_debug
}

function cmd_run_asm() {
    clean
    
    local asm_path="${TEST_PATH}"
    local output_path="${LIB_PATH}"
    local output_program=${BIN_PATH}/${FILE} 

    compile_and_run_asm $output_path $asm_path $output_program
}

# Use this command to just load all functions
function cmd_no_run() {
    return
}

function cmd_compile_run_debug() {
    compile_debug_libs
    compile_and_run_debug
}


### Tooling

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

# It's possible to pass the test name to launch only this one.
function run_test() {

    local param_include_paths="$include_paths"
    local param_object_files="$object_files"
    local test_filter="*"

    execute "Load test tools" \
    source ${TEST_TOOLS_PATH}/test_generate.sh

    for f in ${TEST_PATH}/${test_filter}.test.c
    do
        include_paths="$param_include_paths"
        object_files="$param_object_files"
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"
        # Generate test files
        execute "Generate test file" \
        build_test_file ${TEST_PATH}/${test_name}.test.c ${BIN_PATH}/${test_name}.test.c
        
        MAIN_FILENAME=${test_name}.test
        include_paths+="${TEST_TOOLS_PATH} "
        #include_paths+="${ROOT_PATH}/examples/print "
        
        compile_asm $LIB_PATH ${ASM_PATH}
        object_files+="$(file_list ${LIB_PATH}/*.o)"

        local output_program=${BIN_PATH}/${MAIN_FILENAME}.o
        compile ${BIN_PATH}/${MAIN_FILENAME}.c ${output_program}

        execute "Execute test" \
        ${output_program} $@
    done
}

function compile_and_run_asm() {
    local output_path="$1"
    local asm_path="$2"
    local output_program="$3"

    compile_asm ${output_path} ${asm_path}
    local object_files="$(file_list ${output_path}/*.o)"
    execute "Link" \
    ld $object_files -o ${output_program}

    ${output_program}
}

function run_run() {
    compile_asm $LIB_PATH ${TEST_PATH}
    object_files+="$(file_list ${LIB_PATH}/*.o)"

    include_paths+="${PROJECT_PATH} "
    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    compile ${TEST_PATH}/$MAIN_FILENAME.c ${output_program}

    execute "Execute" \
    ${output_program}
}

function compile_debug_libs() {
    # print.o and debug.o need to be compiled
    compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/print
    compile_asm ${LIB_PATH} ${ROOT_PATH}/examples/debug
    object_files+="$(file_list ${LIB_PATH}/*.o)"
}

function compile_and_run_debug() {

    echo "output_program  => $output_program"
    
    local debug_data_file="$DEBUG_PATH/debug.data"
    MAIN_FILENAME=$MAIN_FILENAME.debug

    compile_asm $LIB_PATH $DEBUG_PATH
    object_files+="$(file_list ${LIB_PATH}/*.o)"

    include_paths+="${PROJECT_PATH} "
    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    compile ${DEBUG_PATH}/$MAIN_FILENAME.c ${output_program}

    ${output_program} $debug_data_file

    execute "Run debug" \
    $PYTHON format_debug.py $debug_data_file $DEBUG_PATH
}


# Extract all files matching the path pattern given as first parameter.
# $1: path pattern (example: lib/*.o).
function file_list() {
    local path_pattern=$1
    local files=""
    shopt -s nullglob
    for file in $path_pattern
    do
        files+=" ${file} "
    done
    shopt -u nullglob
    echo "$files"
}

# Compile all files in [asm_path] to the output [output_path] folder.
# $1: Output path where .o will be generated.
# $2: Source path where .asm are.
function compile_asm() {
    local output_path=$1
    local asm_path=$2
    mkdir -p ${output_path}
    local output_files=""
    log_debug "Compile asm files: $(ls $asm_path/*.asm)"
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

    includes=""
    for include_file in ${include_paths}
    do 
        includes+="-I${include_file} "
    done

    log_debug "===  Compile Debug  ==="
    log_debug "   c_file: $c_file"
    log_debug "   object_files: $object_files"
    log_debug "   include_paths: $include_paths"
    log_debug "   includes: $includes"
    log_debug "   output_program: $output_program"

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

    for script_file in "$SCRIPT_PATH/$CURRENT_SCRIPT_NAME" "$ABSOLUTE_PROJECT_PATH/$ORIGIN_SCRIPT_NAME" 
    do
        grep "[f]unction cmd_.*() {" "$script_file" | sed 's/function cmd_\(.*\)(.*/  - \1/g' 
    done
}

####################################################################


source "$SCRIPT_PATH/log.sh"
show_variables

# You can redefine one of the command in your own file:
# function custom_cmd_test() { ... }

USE_CASE=cmd_$1
CUSTOM_USE_CASE=custom_$USE_CASE
COMMIT_COUNTER=0
if [[ -z $1 || -z $(command -v $USE_CASE) ]]; then
    help
else

    echo "# Replay script" > "$SCRIPT_RECORD"
    echo "pushd $(realpath --relative-to="${ROOT_PATH}/work" "${ABSOLUTE_PROJECT_PATH}") > /dev/null" >> "$SCRIPT_RECORD"
    if [[ -z $(command -v $CUSTOM_USE_CASE) ]]; then
        echo "Execute command $USE_CASE"
        $USE_CASE "${@:2}"
    else
        echo "Execute custom command: $CUSTOM_USE_CASE"
        $CUSTOM_USE_CASE "${@:2}"
    fi
    echo "popd > /dev/null" >> "$SCRIPT_RECORD"
fi
