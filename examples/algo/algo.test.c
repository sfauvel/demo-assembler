

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

int next_generation(int /* neighbor */, int /* state*/);

#define DEAD 0
#define ALIVE 1

TEST void test_cell_with_more_then_3_neighbor_is_dead() {
    _assertIntEq(DEAD, next_generation(4, DEAD));
}

TEST void test_dead_cell_or_alive_cell_with_3_neighbor_is_alive() {
    _assertIntEq(ALIVE, next_generation(3, DEAD));
}

TEST void test_cell_with_less_than_2_neighbor_is_dead() {
    _assertIntEq(DEAD, next_generation(1, DEAD));
    _assertIntEq(DEAD, next_generation(0, DEAD));
}

TEST void test_dead_cell_with_2_neighbor_is_dead() {
    _assertIntEq(DEAD, next_generation(2, DEAD));
}

TEST void test_alive_cell_with_2_neighbor_is_alive() {
    _assertIntEq(ALIVE, next_generation(2, ALIVE));
}


RUN_TESTS()