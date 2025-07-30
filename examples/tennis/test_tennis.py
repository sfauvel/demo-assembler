import ctypes
from pathlib import Path
import pytest

LIB_PATH="target"
LIB_NAME="tennis"

def load_shared_library(lib_path: Path) -> ctypes.CDLL:
    return ctypes.CDLL(lib_path.absolute())

class TennisWrapper:
    def __init__(self, lib):
        self._lib = lib
        # self._lib.tennis_score.argtypes = ()
        self._lib.tennis_score.restype = ctypes.c_char_p

    def start_game(self):
        self._lib.start_game()

    def a_score(self):
        self._lib.a_score()

    def b_score(self):
        self._lib.b_score()

    def tennis_score(self):
        return self._lib.tennis_score().decode('utf-8')

class TestProg:
    @pytest.fixture(scope="module")
    def tennis_lib(self):
        yield TennisWrapper(load_shared_library(Path(f"{LIB_PATH}/{LIB_NAME}.so")))
        
    def test_found_0_0(self, tennis_lib):
        tennis_lib.start_game();
        score = tennis_lib.tennis_score()
        assert "0-0" == score

    def test_found_15_0_when_A(self, tennis_lib):
        tennis_lib.start_game();
        tennis_lib.a_score();
        assert "15-0" == tennis_lib.tennis_score()

    def test_found_0_15_when_B(self, tennis_lib):
        tennis_lib.start_game();
        tennis_lib.b_score();
        assert "0-15" == tennis_lib.tennis_score()

    def test_found_30_0_when_AA(self, tennis_lib):
        tennis_lib.start_game();
        tennis_lib.a_score();
        tennis_lib.a_score();
        assert "30-0" == tennis_lib.tennis_score()

    def test_found_45_0_when_AAA(self, tennis_lib):
        tennis_lib.start_game();
        tennis_lib.a_score();
        tennis_lib.a_score();
        tennis_lib.a_score();
        assert "45-0" == tennis_lib.tennis_score()


    def test_found_15_30_when_BAB(self, tennis_lib):
        tennis_lib.start_game();
        tennis_lib.b_score();
        tennis_lib.a_score();
        tennis_lib.b_score();
        assert "15-30" == tennis_lib.tennis_score()
