

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include "../test/test.h"

int64_t return_5();
int64_t increment(int64_t);
int64_t add_three_values(int64_t, int64_t, int64_t);
int64_t add_2_3_and_6_with_call();
int64_t plus_1_and_add(int64_t, int64_t, int64_t);


TEST void should_return_5() {
    _assertInt64Eq((int64_t)5, return_5());
}

TEST void should_increment() {
    _assertInt64Eq((int64_t)6, increment(5));
}

TEST void should_add_three() {
    _assertInt64Eq((int64_t)25, add_three_values(5, 7, 13));
}


TEST void should_call_add_with_2_3_6() {
    _assertInt64Eq((int64_t)11, add_2_3_and_6_with_call());
}

TEST void should_add_1_and_add() {
    _assertInt64Eq((int64_t)10, plus_1_and_add(2, 5, 0));
}

RUN_TESTS()