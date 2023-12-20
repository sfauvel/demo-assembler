

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


#include <day1.h>

/// is_digit
TEST void test_is_digit_return_the_digit() {
    _assertIntEq(0, is_digit("0"));
    _assertIntEq(1, is_digit("1"));
    _assertIntEq(9, is_digit("9"));
}
TEST void test_is_digit_return_minus_1_when_not_a_digit() {
    _assertIntEq(-1, is_digit("X"));
    _assertIntEq(-1, is_digit("\n"));
    _assertIntEq(-1, is_digit(""));
}

/// calibration

TEST void test_should_extract_first_and_last_number_finish_by_new_line() {
    _assertIntEq(13, calibration_from_buffer("1abc3\n"));
}

TEST void test_should_extract_first_and_last_number() {
    _assertIntEq(9, calibration_from_buffer("0abc9"));
}

TEST void test_should_extract_first_and_last_number_when_not_at_the_end() {
    _assertIntEq(13, calibration_from_buffer("1abc3def"));
}

TEST void test_should_extract_first_and_last_number_when_not_at_the_beginning() {
    _assertIntEq(13, calibration_from_buffer("ab1c3def"));
}

TEST void test_should_extract_first_and_last_number_when_some_numbers_between() {
    _assertIntEq(12, calibration_from_buffer("ab1cd4efg2hijk"));
}

TEST void test_concat_the_digit_with_itself_when_the_first_and_the_last() {
    _assertIntEq(77, calibration_from_buffer("treb7uchet"));
}

TEST void test_no_digit_should_return_0() {
    _assertIntEq(0, calibration_from_buffer("trebuchet"));
}

TEST void test_should_extract_sum_of_lines() {
    _assertIntEq(71, calibration_from_buffer("1abc3\n5def8"));
}

TEST void test_advent_of_code_example() {
    _assertIntEq(142, calibration_from_buffer("1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"));
}

TEST void test_advent_from_input_file() {
    _assertIntEq(55172, calibration_from_file("../examples/adventofcode/input.txt"));
}



RUN_TESTS()