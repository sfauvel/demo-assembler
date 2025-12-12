
from lib import lib

if __name__ == "__main__":
    print(f"Result from C: {lib.get_value()}")
    print(f"Result from C: {lib.get_hello().decode('utf-8')}", end="")
    lib.say_hello()