

/* runner.c */
#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <test.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include "print.h"

void test_asm_println_between_text();


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


TEST void test_print_text() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_text("abcdefghijklmnopqrstuvwxyz");

    _assertStringEq("abcdefghijklmnopqrstuvwxyz", restore_stdout(stdout_switch));
}

TEST void test_print_with_only_0_zero_in_the_middle() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    char text[] = "abcdefghijklmnopqrstuvwxyz";
    text[4] = '\0';
    print_text(text);

    _assertStringEq("abcd", restore_stdout(stdout_switch));
}


TEST void test_print_empty_string() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_text("abc");
    print_text("");
    print_text("def");

    _assertStringEq("abcdef", restore_stdout(stdout_switch));
    // If we just change and restore stdout without writing anything, there is a problem
    // It's the same if we just call print_text with an empty string
    // There is a warning using printf with an empty string.
}

TEST void test_print_line_feed() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_ln();

    _assertStringEq("\n", restore_stdout(stdout_switch));
}

TEST void test_print_line_feed_between_two_text() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);
    
    test_asm_println_between_text();

    _assertStringEq(">>>\n<<<", restore_stdout(stdout_switch));
}

TEST void test_print_number_0() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_number(0);

    _assertStringEq("0", restore_stdout(stdout_switch));
}


TEST void test_print_number() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_number(1024);

    _assertStringEq("1024", restore_stdout(stdout_switch));
}

TEST void test_print_long_number() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_number(123456789123456789);

    _assertStringEq("123456789123456789", restore_stdout(stdout_switch));
}


TEST void test_print_long_number_with_zero() {
    char buffer[1024] = {0};
    StdOutSwitch stdout_switch = change_stdout(buffer);

    print_number(100000000000000002);

    _assertStringEq("100000000000000002", restore_stdout(stdout_switch));
}
