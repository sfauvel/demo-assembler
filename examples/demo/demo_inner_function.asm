; -----------------------------------------------------------------------------
; Can call a function and continue using returned value.
;
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  inner_function_return_543     ;

        section .text
inner_function_return_543:
        mov rdi, 3          ; first parameter to function
        mov rsi, 40         ; second parameter to function
        call my_function    ; call function
        add rax, 500        ; add 500 to returned value that is in in rax
        ret

my_function:
        mov rax, rdi
        add rax, rsi
        ret