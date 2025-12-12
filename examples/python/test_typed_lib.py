from lib import lib
from typing import Any
import pytest

class TestProg:
    def capture_stdout(self, capfd: pytest.CaptureFixture[Any]) -> str:
        out, _ = capfd.readouterr()
        return str(out)

    def test_say_hello(self, capfd: pytest.CaptureFixture[Any]) -> None:
        lib.say_hello()
        assert self.capture_stdout(capfd) == "Hello world\n"

    def test_get_hello(self) -> None:
        print(type(lib.get_hello()))
        assert lib.get_hello().decode('utf-8') == "Hello world\n"

    def test_get_value(self) -> None:
        assert lib.get_value() == 42
        
    def test_add_5(self) -> None:
        assert lib.add_5(7) == 12

    def test_add(self) -> None:
        assert lib.add(7, 11) == 18

    
