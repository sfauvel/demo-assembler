

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

TEST void should_found_0_15_when_B() {
    start_game();
    b_score();
    _assertStringEq("0-15", tennis_score());
}

TEST void should_found_30_0_when_AA() {
    start_game();
    a_score();
    a_score();
    _assertStringEq("30-0", tennis_score());
}

TEST void should_found_45_0_when_AAA() {
    start_game();
    a_score();
    a_score();
    a_score();
    _assertStringEq("45-0", tennis_score());
}
RUN_TESTS()