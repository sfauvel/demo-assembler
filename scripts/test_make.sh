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

# Load script to test
. ./make.sh no_run

# Execute
SHUNIT2_PATH=../test
. ${SHUNIT2_PATH}/shunit2

# To run it:
# ./test_make.sh
# To run on each change
# while true; do inotifywait -q -r -e create,modify,delete .; clear; bash ./test_make.sh; date; done;