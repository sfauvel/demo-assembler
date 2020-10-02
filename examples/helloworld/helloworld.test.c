

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

char* hello_world();
char* to_roman();

TEST void test_say_hello() {
    _assertStringEq("Hello", hello_world());
}

TEST void test_1_is_I() {
    _assertStringEq("I", to_roman(1));
}

TEST void test_5_is_V() {
    _assertStringEq("V", to_roman(5));
}

TEST void test_10_is_X() {
    _assertStringEq("X", to_roman(10));
}

TEST void test_2_is_II() {
    _assertStringEq("II", to_roman(2));
}

RUN_TESTS()