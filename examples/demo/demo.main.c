

#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <demo_if.h>
#include <demo_inner_function.h>
#include <demo_param.h>

int method_return_2();
int method_return_3();

char* string_get_param(char*);
char* string_substring_from(char*, int);

int variable_return(int);



int my_method(int, int, int);
int algo_to_debug_X(int, int, int);
int algo_to_debug_Y(int, int, int);


int main(int argc, char **argv) {
   printf("if_equals_10(9): %d\n", if_equals_10(9));
   printf("if_equals_10(10): %d\n", if_equals_10(10));
   printf("if_equals_10(11): %d\n", if_equals_10(11));
}
