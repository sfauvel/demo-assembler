

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


void display_stack();
void test_1_push();
void test_3_push();
void test_reinit_current_stack_head();

int starts_with(char* s1, char* s2) {
    while (*s1 != 0 && *s2 != 0) {
        if (*s1 != *s2) {
            return 0;
        }
        s1++;
        s2++;
    }
    if (*s1 == 0) {
        return 1;
    }
    return 0;
}

struct StdOutSwitch {
    int saved_stdout;
    int max_size;
    int out_pipe[2];
    char* buffer;
};
typedef struct StdOutSwitch StdOutSwitch;

StdOutSwitch change_stdout(char* buffer) {
    int SIZE=1024;
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


TEST void test_display_stack_1_item() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    test_1_push();

    _assertStringEq("101,", restore_stdout(stdout_switch));
}

void wrap_test_3_push() {
    test_3_push();
}

TEST void test_display_stack_3_item() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);
    
    wrap_test_3_push();
    restore_stdout(stdout_switch);

    _assert(starts_with("103,102,101,", buffer));
}

TEST void test_display_reinit_current_stack_head() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);
  
    test_reinit_current_stack_head();

    _assertStringEq("102,101,", restore_stdout(stdout_switch));
}


RUN_TESTS()