/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <test.h>

int maxofthree(int, int, int);

void should_found_max_of_threehen_first_number() {
    _assertIntEq((int)11, maxofthree(11, 5, 7));
}

void should_found_max_of_threehen_second_number() {
    _assertIntEq((int)15, maxofthree(1, 15, 7));
}

void should_found_max_of_threehen_third_number() {
    _assertIntEq((int)7, maxofthree(1, 5, 7));
}
