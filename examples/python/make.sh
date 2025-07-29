nasm -felf64 prog.asm
ld -shared prog.o -o prog.so
# -z noexecstack to avoid a warning
gcc -z noexecstack prog.main.c prog.o
./a.out
python prog.py

# https://docs.python.org/3/library/ctypes.html
# https://realpython.com/python-bindings-overview/