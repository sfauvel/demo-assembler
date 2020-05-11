

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include "../test/test.h"
#include <string.h>



char* tennis_score();
void a_score();
void b_score();
void start_game();


TEST void should_found_0_0() {
    start_game();
    _assertStringEq("0-0", tennis_score());
}

TEST void should_found_15_0_when_A() {
    start_game();
    a_score();
    _assertStringEq("15-0", tennis_score());
}



RUN_TESTS()