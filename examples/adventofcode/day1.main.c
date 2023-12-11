#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <day1.h>

int main(int argc, char **argv) {
    int result = sum_of_lines("1abc3\n5def8");
    printf("Result:%d\n", result);
}