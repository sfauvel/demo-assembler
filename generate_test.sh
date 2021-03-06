#!/usr/bin/env bash

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

rm -rf target
mkdir target
mkdir target/src
mkdir target/obj
mkdir target/objtest

for test in "$@"
do
    build_test_file test/$test.test.c target/src/$test.test.c
done


