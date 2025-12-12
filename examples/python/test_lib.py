# Simple library without type so we ignore type checking on the file
# type: ignore

import ctypes
from pathlib import Path
import pytest

LIB_PATH="target"
LIB_NAME="lib"

class TestProg:
    @pytest.fixture(scope="module")
    def prog_lib(self):
        # Load the shared library
        prog_lib = ctypes.CDLL(Path(f"{LIB_PATH}/{LIB_NAME}.so"))
        
        # Define function signatures
        prog_lib.get_hello.argtypes = ()
        prog_lib.get_hello.restype = ctypes.c_char_p

        # Return library object
        yield prog_lib
        
    def capture_stdout(self, capfd):
        out, _ = capfd.readouterr()
        return str(out) 

    def test_say_hello(self, prog_lib, capfd):
        prog_lib.say_hello()

        assert self.capture_stdout(capfd) == "Hello world\n"

    def test_get_hello(self, prog_lib):
        assert prog_lib.get_hello().decode('utf-8') == "Hello world\n"

    def test_get_value(self, prog_lib):
        assert prog_lib.get_value() == 42
        
    def test_add_5(self, prog_lib):
        assert prog_lib.add_5(7) == 12

    def test_add(self, prog_lib):
        assert prog_lib.add(7, 11) == 18

    
