import ctypes
import typing
from pathlib import Path

LIB_PATH="target"
LIB_NAME="lib"

## Define the interface of the shared library to help MyPy with type checking
class LibInterface:
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
    
def _init() -> LibInterface:
    # Load the shared library
    _lib = ctypes.CDLL(Path(f"{LIB_PATH}/{LIB_NAME}.so").absolute())
    
    # Define function return types and argument types
    _lib.get_hello.argtypes = ()
    _lib.get_hello.restype = ctypes.c_char_p
    
    # Cast with the interface
    return typing.cast(LibInterface, _lib)

lib = _init()
