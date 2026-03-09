#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

void say_hello(void);   // Import symbol


int main(int argc, char **argv) {
   say_hello();  // call the function written in assembler
}