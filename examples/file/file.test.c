

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>


int read_file(int);
char* read_file_to_buffer(int);


TEST void test_read_file() {
    //_assertIntEq(88, read_file(20));
    char* buffer = read_file_to_buffer(6);
   // printf("Result: %s", buffer);

    _assertStringEq("42", read_file_to_buffer(6));
}

