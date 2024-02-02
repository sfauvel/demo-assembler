

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


int add_5(int);


TEST void test_print_registry_stdout() {
    _assertIntEq(25, add_5(20));
}
