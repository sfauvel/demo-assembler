import ctypes
from pathlib import Path
import pytest

LIB_PATH="target"

def load_shared_library(lib_name: str) -> ctypes.CDLL:
    lib_path = Path(f"{LIB_PATH}/{lib_name}.so").absolute()
    return ctypes.CDLL(lib_path)

class TestProg:
    @pytest.fixture(scope="module")
    def prog_lib(self):
        yield load_shared_library("prog")
        
    def test_say_hello(self, prog_lib, capfd):
        prog_lib.say_hello()

        captured = capfd.readouterr()
        text = f"{captured.out}" 
        assert text == "Hello\n"

    def test_get_value(self, prog_lib):
        assert prog_lib.get_value() == 42
        

    def test_add_5(self, prog_lib):
        assert prog_lib.add_5(7) == 12

    def test_add(self, prog_lib):
        assert prog_lib.add(7, 11) == 18
