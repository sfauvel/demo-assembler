import ctypes
from pathlib import Path
from typing import Any, Generator
import pytest

LIB_PATH="target"
LIB_NAME="lib"

# Define the interface of the shared library to help MyPy with type checking
class LibInterface:
    @staticmethod
    def load() -> ctypes.CDLL:
        # Load the shared library
        prog_lib = ctypes.CDLL(Path(f"{LIB_PATH}/{LIB_NAME}.so").absolute())
        
        # Define function signatures
        prog_lib.get_hello.argtypes = ()
        prog_lib.get_hello.restype = ctypes.c_char_p
        return prog_lib

    # Define method signatures only for type checking
    def say_hello(self) -> None:
        raise NotImplementedError

    def get_hello(self) -> bytes:
        raise NotImplementedError

    def get_value(self) -> int:
        raise NotImplementedError

    def add_5(self, x: int) -> int:
        raise NotImplementedError

    def add(self, x: int, y: int) -> int:
        raise NotImplementedError

class TestProg:
    @pytest.fixture(scope="module")
    def prog_lib(self) -> Generator[ctypes.CDLL, None, None]:
        yield LibInterface.load()
        
    def capture_stdout(self, capfd: pytest.CaptureFixture[Any]) -> str:
        out, _ = capfd.readouterr()
        return str(out)

    def test_say_hello(self, prog_lib: LibInterface, capfd: pytest.CaptureFixture[Any]) -> None:
        prog_lib.say_hello()

        assert self.capture_stdout(capfd) == "Hello world\n"

    def test_get_hello(self, prog_lib: LibInterface) -> None:
        print(type(prog_lib.get_hello()))
        assert prog_lib.get_hello().decode('utf-8') == "Hello world\n"

    def test_get_value(self, prog_lib: LibInterface) -> None:
        assert prog_lib.get_value() == 42
        
    def test_add_5(self, prog_lib: LibInterface) -> None:
        assert prog_lib.add_5(7) == 12

    def test_add(self, prog_lib: LibInterface) -> None:
        assert prog_lib.add(7, 11) == 18

    
