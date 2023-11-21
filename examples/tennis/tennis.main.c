

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <tennis.h>

int main(int argc, char **argv) {
    
    start_game();
    printf("A ");
    a_score();
    printf("A ");
    a_score();
    printf("A ");
    a_score();

    printf("=> %s\n", tennis_score());
}
