

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

char* tennis_score();
void a_score();
void b_score();
void start_game();

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
