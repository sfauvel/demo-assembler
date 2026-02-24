#!/usr/bin/env bash

# Replace keywords in c files to generate a real c file that could be compile and execute to play tessts.
# Usage:
# build_test_file [Source C File] [Target C file]

function write() {
    TEXT=$1
    echo -en "${TEXT}" >> $TEST_FILE
}

function writeln() {
    write "$1\\n"
}

function write_tests() {
    grep "^TEST " $TEST_FILE | while read -r test ; do
        tmp=${test}
        tmp=${tmp/TEST int /}
        tmp=${tmp/TEST void /}
        tmp=${tmp/\(\) {/}
        writeln "    if (!testName || strcmp(testName, \"$tmp\")==0) {_verifyWithName(${tmp}, \"${tmp}\");}"
    done
}

function build_test_file() {

    echo "Build program for file $1"

    TEST_FILE=$2

    cp $1 $TEST_FILE
    tests=$(grep "^TEST " $TEST_FILE)s

    writeln ""
    writeln "int main(int argc, char **argv) { "
    writeln "    const char* testName = argv[1];"
    write_tests
    writeln "    return reportTests() ? 0 : 1;"
    writeln "}"
    writeln ""
}

