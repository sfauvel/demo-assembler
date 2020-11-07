

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
#define DEAD 'X'
#define ALIVE 'O'

TEST void dead_cell_with_0_neighbour_stay_dead() {   
    _assertIntEq(DEAD, next_state_for(DEAD, 0));
}

TEST void dead_cell_with_3_neighbour_become_alive() {   
    _assertIntEq(ALIVE, next_state_for(DEAD, 3));
}

TEST void alive_cell_with_0_neighbour_stay_alive() {   
    _assertIntEq(DEAD, next_state_for(ALIVE, 0));
} 

TEST void alive_cell_with_2_neighbour_stay_alive() {   
    _assertIntEq(ALIVE, next_state_for(ALIVE, 2));
}

TEST void alive_cell_with_3_neighbour_stay_alive() {   
    _assertIntEq(ALIVE, next_state_for(ALIVE, 3));
}

TEST void alive_cell_with_4_neighbour_stay_alive() {   
    _assertIntEq(DEAD, next_state_for(ALIVE, 4));
}


RUN_TESTS()