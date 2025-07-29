import ctypes
from pathlib import Path


def load_library(lib_name: str) -> ctypes.CDLL:
    # Load the shared library
    lib_path = Path(f"{lib_name}.so").absolute()
    return ctypes.CDLL(lib_path)

if __name__ == "__main__":
    c_lib = load_library("prog")

    # Call the C function
    c_lib.say_hello()
    print("")
    
    result = c_lib.get_value()
    print(f"Result from Python: {result}")

    result = c_lib.add_5(7)
    print(f"Result from Python: {result}")

    result = c_lib.add(7, 11)
    print(f"Result from Python: {result}")