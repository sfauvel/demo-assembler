

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

char next_state_for(char, int);

/*
X = Dead
O = Alive
*/
TEST void dead_cell_with_0_neighbour_stay_dead() {   
    _assertIntEq((int)'X', (int)next_state_for('X', 0));
}

TEST void dead_cell_with_3_neighbour_become_alive() {   
    _assertIntEq((int)'O', (int)next_state_for('X', 3));
}

RUN_TESTS()