

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <test.h>

int64_t maxofthree(int64_t, int64_t, int64_t);

TEST void should_found_max_of_threehen_first_number() {
    _assertInt64Eq((int64_t)11, maxofthree(11, 5, 7));
}

TEST void should_found_max_of_threehen_second_number() {
    _assertInt64Eq((int64_t)15, maxofthree(1, 15, 7));
}

TEST void should_found_max_of_threehen_third_number() {
    _assertInt64Eq((int64_t)7, maxofthree(1, 5, 7));
}


RUN_TESTS()