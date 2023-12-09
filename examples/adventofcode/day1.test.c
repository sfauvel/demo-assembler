

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>


int calibration(const char* line);


TEST void test_should_extract_first_and_last_number() {
    _assertIntEq(4, calibration("1abc3"));
}



RUN_TESTS()