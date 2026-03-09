import ctypes
import os
import typing
from pathlib import Path

LIB_NAME="maxofthree"

## Define the interface of the shared library to help MyPy with type checking
class LibInterface:
    # Define method signatures only for type checking
    def maxofthree(self, first:int, second:int, third:int) -> None:
        raise NotImplementedError
    
def _init() -> LibInterface:
    # Load the shared library
    dll_loader = ctypes.LibraryLoader(ctypes.CDLL)
    _lib = dll_loader.LoadLibrary(Path(f"{LIB_NAME}.so"))

    # Cast with the interface
    return typing.cast(LibInterface, _lib)

lib = _init()
