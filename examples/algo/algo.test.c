

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


int next_generation(int);

#define DEAD 0
#define ALIVE 1

TEST void test_cell_with_more_then_3_neighbor_is_dead() {
    _assertIntEq(DEAD, next_generation(4));
}

TEST void test_cell_with_3_neighbor_is_alive() {
    _assertIntEq(ALIVE, next_generation(3));
}


RUN_TESTS()