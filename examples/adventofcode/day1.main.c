#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <day1.h>

int main(int argc, char **argv) {
    int result = calibration("1abc3\n");
    printf("Result:%d\n", result);
}