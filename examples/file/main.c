#include <stdio.h>

char* read_file_to_buffer(const char*);
void write_file(const char*, char*);

int main(int argc, char **argv) {
    const char* FILENAME = "tmp/data.txt";

    write_file(FILENAME, "hello");
    char* buffer = read_file_to_buffer(FILENAME);
    printf("Result: %s\n", buffer);
}