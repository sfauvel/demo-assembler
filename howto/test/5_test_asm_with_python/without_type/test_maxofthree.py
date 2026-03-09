# Simple library without type so we ignore type checking on the file
# type: ignore

import ctypes
from pathlib import Path
import pytest

LIB_NAME="maxofthree"

class TestMaxOfThree:
    @pytest.fixture(scope="module")
    def prog_lib(self):
        # Load the shared library
        prog_lib = ctypes.CDLL(Path(f"{LIB_NAME}.so"))
        
        # Define function signatures (not necessary for int)
        prog_lib.maxofthree.argtypes = (ctypes.c_int, ctypes.c_int)
        prog_lib.maxofthree.restype = ctypes.c_int

        # Return library object
        yield prog_lib

    def test_when_max_is_the_first_number(self, prog_lib):
        assert 11 == prog_lib.maxofthree(11, 5, 7)

    def test_when_max_is_the_second_number(self, prog_lib):
        assert 15 == prog_lib.maxofthree(1, 15, 7)

    def test_when_max_is_the_third_number(self, prog_lib):
        assert 7 == prog_lib.maxofthree(1, 5, 7)

    
