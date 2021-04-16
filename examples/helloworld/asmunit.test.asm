
%include "asmunit.asm"

        global  main

        section .text
main:
    mov rdi, 1
    mov rsi, 2
    call assert_equals
    mov rdi, rax                ; assert_equals return  value

    mov rsi, 1                  ; expected value: 1 = false   
    cmp rdi, rsi
    jne fail

    success:
        mov rax, 0
        jmp next

    fail:
        mov rax, 1
        
    next:
        
    mov rdi, 2
    mov rsi, 2
    call assert_equals
    mov rdi, rax                ; assert_equals return  value

    mov rsi, 0                  ; expected value: 0 = true
    cmp rdi, rsi
    jne next_fail

    next_success:
        mov rax, 0
        jmp end_main

    next_fail:
        mov rax, 1
        
    end_main:
        ret