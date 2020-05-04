

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include "../test/test.h"
#include <string.h>



char* tennis_score();

TEST void should_found_0_0() {
    _assertStringEq("0-0", tennis_score());
}

RUN_TESTS()