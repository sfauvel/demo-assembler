#!/usr/bin/env bash

# This script is executing from the sub-project folder.
# 
# We can define some variables to customize compilation
# include_paths: Folder add as included paths
# ASM_PATH: PAth where are .asm files
# TEST_PATH: Path where are test.c files
# MAIN_FILENAME: Name of the file containg `main` without extension. Default value is `main`
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

WORK_PATH=${ROOT_PATH}/work
BIN_PATH=${WORK_PATH}/target
LIB_PATH=${WORK_PATH}/lib
DEBUG_PATH=${WORK_PATH}/debug
SCRIPT_RECORD=${WORK_PATH}/rerun.sh
chmod u+x "$SCRIPT_RECORD"

# Paths relative to the project
# By default the file name used is the name of the directory
ABSOLUTE_PROJECT_PATH=$(pwd)
FILE=${FILE:=$(basename $(pwd))}
ASM_PATH=${ASM_PATH:=.}    # Assembler files
TEST_PATH=${TEST_PATH:=.}  # Test files in c

if [[ -z "$MAIN_FILENAME" ]]; then
    MAIN_FILENAME=main
fi

# LANGUAGE of the main file
# The `c` file is prioritized as `main` file because, if there is one it's probably the launcher to execute the `asm` code. 
if [[ -f "$MAIN_FILENAME.c" ]]; then
    LANGUAGE=C
elif [[ -f "$MAIN_FILENAME.asm" ]]; then
    LANGUAGE=ASM
else
    LANGUAGE=UNKNOWN
fi

PROJECT_PATH=.

# Constants
PYTHON=python3

#####

function show_variables() {
    log_debug "${GREEN}===  Variables  ===${NO_COLOR}"
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
    log_debug "   LANGUAGE=$LANGUAGE"
    log_debug "-------------------"
    log_debug ""
}

### Commands

function cmd_test() {
    clean
    run_test $@
}

function cmd_pytest() {
    clean
    run_pytest $@
}

function cmd_run() {
    clean

    local output_program=${BIN_PATH}/$MAIN_FILENAME.o
    
    run_run $output_program
}

function cmd_debug() {
    clean

    OPTION_DEBUG=-g
    local output_program=${BIN_PATH}/${MAIN_FILENAME}.o
    
    compile_asm
    compile_program ${output_program}

    if [[ "$LANGUAGE" == "ASM" ]] then
        start_label="_start"
    else 
        start_label="main"
    fi
    generate_gdb_file $BIN_PATH/test.gdb $start_label

    local debug_log_file=$BIN_PATH/output.log
    run_debug_prog ${output_program} $BIN_PATH/test.gdb > $debug_log_file
    
    python $SCRIPT_PATH/debug_doc.py "$debug_log_file"
}

function compile_program() {
    local output_program=$1

    if [[ "$LANGUAGE" == "ASM" ]] then
        link_asm_prog ${LIB_PATH} ${output_program}
    else 
        include_paths+="${PROJECT_PATH} "
        compile ${TEST_PATH}/$MAIN_FILENAME.c ${output_program}
    fi
}

# Use this command to just load all functions
function cmd_no_run() {
    return
}

### Tooling

function run_debug_prog() {
    local prog_file=$1
    local debug_command_file=$2
    execute "Run program with gdb..." \
    gdb ${prog_file} --batch --command=$debug_command_file
}


# Generate a debug script to begin from a label and log regsiter step by step
function generate_gdb_file() {
    local GDB_FILE="$1"
    local START_LABEL=$2
    echo "" > $GDB_FILE
    echo "b $START_LABEL" >> $GDB_FILE
    echo "run" >> $GDB_FILE
    for i in $(echo {1..100});
    do
        echo "printf \"========\n\"" >> $GDB_FILE
        echo "info registers" >> $GDB_FILE
        echo "printf \"-----------------------------------------------------\n\"" >> $GDB_FILE
        echo "nexti" >> "$GDB_FILE"
    done
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

    execute "Load test tools" \
    source ${TEST_TOOLS_PATH}/test_generate.sh

    for f in $(file_list ${TEST_PATH}/'*.test.c')
    do
        include_paths="$param_include_paths"
        object_files="$param_object_files"
        filename="$(basename -- $f)"
        test_name="${filename%.test.c}"
        
        execute "Generate test file" \
        build_test_file ${TEST_PATH}/${test_name}.test.c ${BIN_PATH}/${test_name}.test.c
        
        MAIN_FILENAME=${test_name}.test
        include_paths+="${TEST_TOOLS_PATH} "
        #include_paths+="${ROOT_PATH}/examples/print "
    
        compile_asm

        local output_program=${BIN_PATH}/${MAIN_FILENAME}.o
        compile ${BIN_PATH}/${MAIN_FILENAME}.c ${output_program}

        execute "Execute test" \
        ${output_program} $@
    done
}

# We can pass pytest parameters. They will be added to the pytest command.
function run_pytest() {
    compile_asm

    for file in $(file_list ${LIB_PATH}/'*.o')
    do
        execute "Create shared library " \
        ld -shared $file -o ${file/.o/.so}
    done

    execute "Execute pytest" \
    LD_LIBRARY_PATH=${LIB_PATH} pytest $@
}


function run_run() {
    local output_program="$1"

    compile_asm
    compile_program "${output_program}"
    
    execute "Execute" \
    ${output_program}
}

# Compile all files in [asm_path] to the output [output_path] folder.
# $1: Output path where .o will be generated.
# $2: Source path where .asm are.
function compile_asm() {
    local output_path="${LIB_PATH}"
    local asm_path="${ASM_PATH}"

    mkdir -p ${output_path}
    log_debug "Compile asm files: $(file_list $asm_path/'*.asm')"
    for asm_file in $(file_list $asm_path/'*.asm')
    do
        [ -f "$asm_file" ] || continue
        local filename=$(extract_filename $asm_file asm)
        local output_file=${output_path}/${filename}.o
        
        execute "Compile asm file: ${asm_file##*/}" \
        nasm $asm_file ${OPTION_DEBUG} -o ${output_file} -i ${asm_path} -felf64
    done

}

# Link all '.o' files to make a program
# It should be have a '_start' in one file.
function link_asm_prog() {
    local output_path="$1"
    local output_program="$2"

    local object_files="$(file_list ${output_path}/'*.o')"
    execute "Link" \
    ld ${OPTION_DEBUG} $object_files -o ${output_program}
}

# Compile a '.c' file
# $1: the c file
# $2: output file
# object_files: additional '.o' files (all '.o' in LIB_PATH are already added)
# includes: paths to include
function compile() {
    
    local c_file="$1"
    local output_program="$2"

    local objects="${object_files}"
    objects+="$(file_list ${LIB_PATH}/'*.o')"

    local includes=""
    for include_file in ${include_paths}
    do 
        includes+="-I${include_file} "
    done

    log_debug "${GREEN}===  Compile Debug  ===${NO_COLOR}"
    log_debug "   c_file: $c_file"
    log_debug "   objects: $objects"
    log_debug "   include_paths: $include_paths"
    log_debug "   includes: $includes"
    log_debug "   output_program: $output_program"

    execute "Compile" \
    gcc -no-pie ${OPTION_DEBUG} -z noexecstack ${c_file} ${objects} ${includes} -o ${output_program}    
}

function extract_filename() {
    local file=$(basename $1)
    local extension=$2
    echo ${file%.${extension:=*}}
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
    echo "pushd $(realpath --relative-to="${WORK_PATH}" "${ABSOLUTE_PROJECT_PATH}") > /dev/null" >> "$SCRIPT_RECORD"
    if [[ -z $(command -v $CUSTOM_USE_CASE) ]]; then
        echo "Execute command $USE_CASE"
        $USE_CASE "${@:2}"
    else
        echo "Execute custom command: $CUSTOM_USE_CASE"
        $CUSTOM_USE_CASE "${@:2}"
    fi
    echo "popd > /dev/null" >> "$SCRIPT_RECORD"
fi
