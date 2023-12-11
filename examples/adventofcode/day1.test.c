

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


TEST void test_should_extract_first_and_last_number() {
    _assertIntEq(13, calibration("1abc3\n"));
    _assertIntEq(9, calibration("0abc9"));
}

TEST void test_should_extract_first_and_last_number_when_not_at_the_end() {
    _assertIntEq(13, calibration("1abc3def"));
}

TEST void test_should_extract_first_and_last_number_when_not_at_the_beginning() {
    _assertIntEq(13, calibration("ab1c3def"));
}

TEST void test_should_extract_first_and_last_number_when_some_numbers_between() {
    _assertIntEq(12, calibration("ab1cd4efg2hijk"));
}

TEST void test_concat_the_digit_with_itself_when_the_first_and_the_last() {
    _assertIntEq(77, calibration("treb7uchet"));
}

TEST void test_should_extract_calibration_until_carriage_return() {
    _assertIntEq(13, calibration("1abc3\n5def8"));
}

TEST void test_should_extract_sum_of_lines() {
    _assertIntEq(71, sum_of_lines("1abc3\n5def8"));
}

RUN_TESTS()