# Simple library without type so we ignore type checking on the file
# type: ignore

from lib_type import lib


LIB_NAME="maxofthree"

class TestMaxOfThree:
    def test_when_max_is_the_first_number(self):
        assert 11 == lib.maxofthree(11, 5, 7)

    def test_when_max_is_the_second_number(self):
        assert 15 == lib.maxofthree(1, 15, 7)

    def test_when_max_is_the_third_number(self):
        assert 7 == lib.maxofthree(1, 5, 7)

    
