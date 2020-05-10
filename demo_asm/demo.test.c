

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include "../test/test.h"

int64_t return_5();
int64_t increment(int64_t);
int64_t decrement(int64_t);
int64_t add_three_values(int64_t, int64_t, int64_t);
int64_t add_2_3_and_6_with_call();
int64_t plus_1_and_add(int64_t, int64_t, int64_t);
int64_t find_min(int64_t , int64_t );

/////////////////////////////////////////
char* say_hello();
char* say_hello_world();
char* say_hello_world_and_new_line();

/////////////////////////////////////////
int64_t set_unset_value(int64_t);
int64_t set_value_init_to_0(int64_t);


TEST void should_return_5() {
    _assertInt64Eq((int64_t)5, return_5());
}

TEST void should_increment() {
    _assertInt64Eq((int64_t)6, increment(5));
}

TEST void should_decrement() {
    _assertInt64Eq((int64_t)4, decrement(5));
}

TEST void should_add_three() {
    _assertInt64Eq((int64_t)25, add_three_values(5, 7, 13));
}


TEST void should_call_add_with_2_3_6() {
    _assertInt64Eq((int64_t)11, add_2_3_and_6_with_call());
}

TEST void should_add_1_and_add() {
    _assertInt64Eq((int64_t)10, plus_1_and_add(2, 5, 0));
}


TEST void should_find_min() {
    _assertInt64Eq((int64_t)2, find_min(2, 5));
    _assertInt64Eq((int64_t)5, find_min(5, 2));
}

////////////////////////////////////////////////////////

TEST void should_return_Hello() {
    char* result =  say_hello();
    _assertStringEq("Hello", result);    
}

TEST void should_return_HelloWorld() {
    char* result =  say_hello_world();
    _assertStringEq("Hello World", result);    
}

TEST void should_return_HelloWorld_with_carriage_return() {
    char* result =  say_hello_world_and_new_line();
    _assertStringEq("Hello World\n\r", result);    
}

////////////////////////////////////////////////////////

TEST void should_set_value() {
    _assertInt64Eq((int64_t)32, set_unset_value(32));    
    _assertInt64Eq((int64_t)32, set_value_init_to_0(32));   
}

RUN_TESTS()