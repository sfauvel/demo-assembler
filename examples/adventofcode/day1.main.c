#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <day1.h>

int main(int argc, char **argv) {
    sum_of_lines("1abc3\n5def8");
    int result = sum_of_lines("1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet");
    printf("Result:%d\n", result);
}