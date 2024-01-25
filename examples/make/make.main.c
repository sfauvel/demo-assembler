#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int add_5(int);


int main(int argc, char **argv) {
    int result = add_5(7);
    printf("Program:%s\n", argv[0]);
    printf("Result:%d\n", result);
}