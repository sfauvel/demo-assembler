

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

#include "../print/print.h"

void test_asm_fork();

struct StdOutSwitch {
    int saved_stdout;
    int max_size;
    int out_pipe[2];
    char* buffer;
};
typedef struct StdOutSwitch StdOutSwitch;

StdOutSwitch change_stdout(char* buffer) {
    int SIZE=10024;
    StdOutSwitch stdout_switch;
    stdout_switch.max_size = SIZE;
    stdout_switch.buffer=buffer;

    fflush(stdout); //clean everything first

    stdout_switch.saved_stdout = dup(STDOUT_FILENO);  /* save stdout for display later */
    if( pipe(stdout_switch.out_pipe) != 0 ) {          /* make a pipe */
        exit(1);
    }

    dup2(stdout_switch.out_pipe[1], STDOUT_FILENO);   /* redirect stdout to the pipe */
    close(stdout_switch.out_pipe[1]);

    return stdout_switch;
}

char* restore_stdout(StdOutSwitch stdout_switch) {
    fflush(stdout); //clean everything first

    read(stdout_switch.out_pipe[0], stdout_switch.buffer, stdout_switch.max_size); /* read from pipe into buffer */
    dup2(stdout_switch.saved_stdout, STDOUT_FILENO);  /* reconnect stdout for testing */
    
    return stdout_switch.buffer;
}


TEST void test_create_fork() {
    char buffer[10024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    test_asm_fork();
    restore_stdout(stdout_switch);

    char* ptr_parent = strstr(buffer, "Parent start");
    _assert(ptr_parent != NULL);
    char* ptr_child = strstr(buffer, "Child start");
    _assert(ptr_child != NULL);
    _assert(ptr_child > ptr_parent);

    char* next = buffer;
    next = strstr(next, "parent");
    _assert(next != NULL);
    next = strstr(next, "child");
    _assert(next != NULL);  // Child after parent 
    next = strstr(next, "child");
    _assert(next != NULL);  // Parent after child

}

RUN_TESTS()