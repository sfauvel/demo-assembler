#!/bin/bash

test_extract_filename() {
  local file_path="project/src/asm/my.file.asm"
  assertEquals "my.file" \
    "$(extract_filename $file_path)"
}

test_extract_filename_with_multiple_extensions() {
  local file_path="project/src/asm/my.file.tar.gz"
  assertEquals "my.file.tar" \
    "$(extract_filename $file_path)"

  assertEquals "my.file" \
    "$(extract_filename $file_path tar.gz)"
}

test_compile_asm() {
  rm -r work
  mkdir -p work/src_asm
  echo -e "
section .text
do_nothing:
    ret" >  work/src_asm/file.asm

  local expected_file=work/build/file.o
  assertFalse "File $expected_file should not exist before execution" "[ -f $expected_file ]"
  compile_asm work/build work/src_asm
  assertTrue "File $expected_file should be generated" "[ -f $expected_file ]"
}

test_compile_several_asm() {
  rm -r work
  mkdir -p work/src_asm
  echo -e "
section .text
do_nothing:
    ret" >  work/src_asm/file_a.asm
  cp work/src_asm/file_a.asm work/src_asm/file_b.asm

  local build_path="work/build"
  assertFalse "[ -f $build_path ]"
  compile_asm $build_path work/src_asm
  assertTrue "[ -f $build_path/file_a.o ]"
  assertTrue "[ -f $build_path/file_b.o ]"
}

test_compile_several_asm_return_files() {
  rm -r work
  mkdir -p work/src_asm
  echo -e "
section .text
do_nothing:
    ret" >  work/src_asm/file_a.asm
  cp work/src_asm/file_a.asm work/src_asm/file_b.asm
  
  return_value=$(compile_asm work/build work/src_asm)
  assertEquals " work/build/file_a.o  work/build/file_b.o " "$return_value"
}

test_compile_and_run_asm_prog() {
  rm -r work
  mkdir -p work/src_asm
  echo -e "
global _start
section .text
_start:
    mov rdi, 34      ; set return code
    mov rax, 60     ; exit syscall
    syscall" >  work/src_asm/prog.asm

  compile_and_run_asm work/build work/src_asm work/prog
  assertEquals 34 $?
}

test_compile_and_run_asm_files_and_run_a_prog() {
  rm -r work
  mkdir -p work/src_asm
  echo -e "
global my_code
section .text
my_code:
    mov rax, 34     ; set return code
    ret
    syscall" >  work/src_asm/lib.asm

  echo -e "
global _start
extern my_code
section .text
_start:
    call my_code
    mov rdi, rax      ; set return code
    mov rax, 60     ; exit syscall
    syscall" >  work/src_asm/prog.asm

  compile_and_run_asm work/build work/src_asm work/prog
  assertEquals 34 $?
}


# Load script to test
. ../make.sh no_run

# Execute
SHUNIT2_PATH=../../test
. ${SHUNIT2_PATH}/shunit2

# To run it, from this directory:
# ./test_make.sh
# To run on each change on test (.) or source (..)
# while true; do inotifywait -q -r -e create,modify,delete . ..; clear; bash ./test_make.sh; date; done;