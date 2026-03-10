#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int add_5(int);


int main(int argc, char **argv) {
    int value = 7;
    int result = add_5(value);
    printf("Result of add_5(%d):%d\n", value, result);
}