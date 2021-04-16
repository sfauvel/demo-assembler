
    section .text

assert_equals:
    cmp rdi, rsi
    jne ae_fail
   
    ae_success:
        mov rax, 0
        jmp end_assert_equals

    ae_fail:
        mov rax, 1
        
    end_assert_equals:
        ret