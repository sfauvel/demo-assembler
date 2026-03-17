

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


char* read_file_to_buffer(char*);
void write_file(char*, char*);


TEST void test_read_file() {
    FILE* file = fopen("./tmp/demo_read_data.txt", "w");
    if (!file) {
        _assertStringEq("File open", "File not found");
    }

    fprintf(file, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    fclose(file);

    _assertStringEq("ABCDEFGHIJKLMNOPQRSTUVWXYZ", read_file_to_buffer("tmp/demo_read_data.txt"));
}

#define TAILLE_MAX 1024
TEST void test_write_file() {
    write_file("tmp/demo_write_data.txt", "abcde");
   
    char buffer[TAILLE_MAX] = "";
    FILE* file = fopen("./tmp/demo_write_data.txt", "r");
    if (!file) {
        _assertStringEq("File open", "File not found");
    }
    char* result = fgets(buffer, TAILLE_MAX, file);
    fclose(file);
    
    _assert(result);
    _assertStringEq("abcde", buffer);
}