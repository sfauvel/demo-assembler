

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

int param_sum_param(int, int, int);

int method_return_2();
int method_return_3();

int if_greater_than_10(int);
int if_lower_than_10(int);
int if_equals_10(int);

int inner_function_return_543();
int inner_function_using_stack_return_658();
int inner_function_using_stack_return_764();

char* string_get_param(char*);
char* string_substring_from(char*, int);

TEST void test_pass_param() {
    _assertIntEq(321, param_sum_param(1, 20, 300));
}

TEST void test_return_2() {
    _assertIntEq(2, method_return_2());
}

TEST void test_return_3() {
    _assertIntEq(3, method_return_3());
}

TEST void test_if_greater_than() {
    _assertIntEq(0, if_greater_than_10(9));
    _assertIntEq(0, if_greater_than_10(10));
    _assertIntEq(1, if_greater_than_10(11));
}

TEST void test_if_lower_than() {
    _assertIntEq(1, if_lower_than_10(9));
    _assertIntEq(0, if_lower_than_10(10));
    _assertIntEq(0, if_lower_than_10(11));
}

TEST void test_if_equals() {
    _assertIntEq(0, if_equals_10(9));
    _assertIntEq(1, if_equals_10(10));
    _assertIntEq(0, if_equals_10(11));
}

TEST void test_using_inner_function() {
    _assertIntEq(543, inner_function_return_543());
}

TEST void test_function_using_stack_with_local_stack() {
    _assertIntEq(658, inner_function_using_stack_return_658());
}

TEST void test_function_using_stack() {
    _assertIntEq(764, inner_function_using_stack_return_764());
}

TEST void test_pass_string_param() {
    _assertStringEq("hello", string_get_param("hello"));
}

TEST void test_substring_from() {
    _assertStringEq("lo", string_substring_from("hello", 3));
}

TEST void test_variable() {
    _assertIntEq(42, variable_return(42));
}


RUN_TESTS()