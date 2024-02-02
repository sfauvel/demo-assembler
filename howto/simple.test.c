/*
* This is a trivial test to show how we can write tests.
*
* test.h contains some utilities to write tests.
* TEST is only a marker to identify test functions.
* a main function that that run all tests is generated and added at the end of the file. 
*/
#include <test.h>

TEST void should_verify_a_simple_addition() {
    _assert(1 + 2 == 3);
}
