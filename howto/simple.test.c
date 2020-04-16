/*
* This is a trivial test to show how we can write tests.
*
* test.h contains some utilities to write tests.
* TEST is only a marker to identify test functions.
* RUN_TESTS is another marker used to generate a main function that run all tests. 
*/
#include "../test/test.h"

TEST void should_verify_a_simple_addition() {
    _assert(1 + 2 == 3);
}

RUN_TESTS()