#include <stdio.h>

int read_file(int);
char* read_file_to_buffer(int);


int main(int argc, char **argv) {
    char* buffer = read_file_to_buffer(6);
    printf("Result:%s\n", buffer);
}