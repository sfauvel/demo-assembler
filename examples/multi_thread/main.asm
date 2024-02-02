
global _start

extern xxx_start

EXIT equ 60

section .text

_start:
    call xxx_start 
    
    xor rdi, rdi    ; return code 0
    mov rax, EXIT     ; exit syscall
    syscall