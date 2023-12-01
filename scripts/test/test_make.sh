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
  echo -e "section .text\ndo_nothing:\n    ret" >  work/src_asm/file.asm

  local expected_file=work/build/file.o
  assertFalse "File $expected_file should not exist before execution" "[ -f $expected_file ]"
  compile_asm work/build work/src_asm
  assertTrue "File $expected_file should be generated" "[ -f $expected_file ]"
}

test_compile_several_asm() {
  rm -r work
  mkdir -p work/src_asm
  echo -e "section .text\ndo_nothing:\n    ret" >  work/src_asm/file_a.asm
  echo -e "section .text\ndo_nothing:\n    ret" >  work/src_asm/file_b.asm

  local build_path="work/build"
  assertFalse "[ -f $build_path ]"
  compile_asm $build_path work/src_asm
  assertTrue "[ -f $build_path/file_a.o ]"
  assertTrue "[ -f $build_path/file_b.o ]"
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