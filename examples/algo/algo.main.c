#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>


int next_generation(int /* neighbor */, int /* state*/);
char* board();
void set_alive(int, int);

int main(int argc, char **argv) {   
    set_alive(1, 1);
    printf("%s", board());
}