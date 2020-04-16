#!/usr/bin/env bash

DOCKER_IMAGE=gcc_test

function write() {
    TEXT=$1
    sed -i "s/RUN_TESTS()/${TEXT}RUN_TESTS()/g" $TEST_FILE
}

function writeln() {
    write "$1\\n"
}

function write_tests() {
    grep "TEST " $TEST_FILE | while read -r test ; do
        tmp=${test}
        tmp=${tmp/TEST int /}
        tmp=${tmp/TEST void /}
        tmp=${tmp/\(\) {/}
        writeln "    _verifyWithName(${tmp}, \"${tmp}\");"
    done

}

function build_test_file() {

    echo "Build program for file $1"

    TEST_FILE=$2

    cp $1 $TEST_FILE
    tests=$(grep "TEST " $TEST_FILE)s

    writeln "int main(int argc, char **argv) { "
    write_tests
    writeln "    return reportTests();"
    writeln "}"
    writeln ""
}


function generateAndRunTest() {
    rm -rf target
    mkdir target
    mkdir target/obj
    mkdir target/objtest

    test = $1
    build_test_file test/$test.test.c target/$test.test.c

    nasm -felf64 $test.asm -o target/obj/$test.o
    gcc ./target/$test.test.c target/obj/$test.o -o target/objtest/$test.out


    for test in "$@"
    do
        echo "=================="
        echo "Run $test.test.o"
        echo "------------------"
        ./target/objtest/$test.out
    done
}

if [ -z $1 ]; then
    echo "File to test must be given"
else
    generateAndRunTest $1
fi