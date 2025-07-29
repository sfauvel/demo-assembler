#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int get_value();


int main(int argc, char **argv) {
    printf("Result from C:%d\n", get_value());
}