

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

char* hello_world();

TEST void say_hello() {
    _assertStringEq("Hello", hello_world());
}

RUN_TESTS()