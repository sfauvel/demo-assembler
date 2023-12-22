

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

/// cmp_string


TEST void test_cmp_string() {
    _assertIntEq(0, cmp_string("one", "one"));

    _assertIntEq(1, cmp_string("one", "two"));
    _assertIntEq(1, cmp_string("onestly", "one"));
    _assertIntEq(1, cmp_string("one", "onestly"));
}


/// is_digit


TEST void test_is_digit_return_the_digit() {
    _assertIntEq(0, is_digit('0'));
    _assertIntEq(1, is_digit('1'));
    _assertIntEq(9, is_digit('9'));
}

TEST void test_is_digit_return_minus_1_when_not_a_digit() {
    _assertIntEq(-1, is_digit('X'));
    _assertIntEq(-1, is_digit('\n'));
    _assertIntEq(-1, is_digit(0));
}

TEST void test_one_is_digit_1() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(1, is_digit('e'));
}

TEST void test_two_is_digit_2() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('t'));
    _assertIntEq(-1, is_digit('w'));
    _assertIntEq(2, is_digit('o'));
}

TEST void test_three_is_digit_3() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('t'));
    _assertIntEq(-1, is_digit('h'));
    _assertIntEq(-1, is_digit('r'));
    _assertIntEq(-1, is_digit('e'));
    _assertIntEq(3, is_digit('e'));
}

TEST void test_four_is_digit_4() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('f'));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('u'));
    _assertIntEq(4, is_digit('r'));
}

TEST void test_five_is_digit_5() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('f'));
    _assertIntEq(-1, is_digit('i'));
    _assertIntEq(-1, is_digit('v'));
    _assertIntEq(5, is_digit('e'));
}

TEST void test_six_is_digit_6() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('s'));
    _assertIntEq(-1, is_digit('i'));
    _assertIntEq(6, is_digit('x'));
}

TEST void test_seven_is_digit_7() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('s'));
    _assertIntEq(-1, is_digit('e'));
    _assertIntEq(-1, is_digit('v'));
    _assertIntEq(-1, is_digit('e'));
    _assertIntEq(7, is_digit('n'));
}

TEST void test_height_is_digit_8() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('e'));
    _assertIntEq(-1, is_digit('i'));
    _assertIntEq(-1, is_digit('g'));
    _assertIntEq(-1, is_digit('h'));
    _assertIntEq(8, is_digit('t'));
}
TEST void test_nine_is_digit_9() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(-1, is_digit('i'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(9, is_digit('e'));
}
TEST void test_exactly_one_to_return_is_digit_1() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(-1, is_digit('x'));

    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('x'));
    _assertIntEq(-1, is_digit('e'));

    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('x'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(-1, is_digit('e'));
}

TEST void test_xxone_is_digit_1() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('x'));
    _assertIntEq(-1, is_digit('x'));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(1, is_digit('e'));
}

TEST void test_several_one() {
    _assertIntEq(-1, is_digit(0));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(1, is_digit('e'));
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(1, is_digit('e'));
}

TEST void test_al_lot_of_one() {
    _assertIntEq(-1, is_digit(0));
    for (int i=0; i<20; i++) {
        _assertIntEq(-1, is_digit('o'));
        _assertIntEq(-1, is_digit('n'));
        _assertIntEq(1, is_digit('e'));
    }
    
}

TEST void test_a_long_string() {
    _assertIntEq(-1, is_digit(0));
    for (int i=0; i<1000; i++) {
        _assertIntEq(-1, is_digit('x'));
    }
    _assertIntEq(-1, is_digit('o'));
    _assertIntEq(-1, is_digit('n'));
    _assertIntEq(1, is_digit('e'));
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

TEST void test_advent_of_code_example_part_1() {
    _assertIntEq(142, calibration_from_buffer("1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"));
}

TEST void test_advent_part_2_line_1() {
    _assertIntEq(29, calibration_from_buffer("two1nine"));
}

TEST void test_advent_part_2_line_2() {
    _assertIntEq(83, calibration_from_buffer("eightwothree"));
}


TEST void test_advent_of_code_example_part_2() {
    _assertIntEq(281, calibration_from_buffer("two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen"));
}


TEST void test_advent_part_2_from_input_file() {
    _assertIntEq(54925, calibration_from_file("../examples/adventofcode/input.txt"));
}



RUN_TESTS()