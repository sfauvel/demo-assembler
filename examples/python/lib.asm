; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  say_hello     ;
        global  get_value     ;
        global  add_5         ;
        global  add           ;

        section .text

say_hello:
        mov rdi, 1      ; stdout fd
        ;mov rsi, hello
        lea rsi, [rel hello]
        mov rdx, 6      ; 5 chars + newline
        mov rax, 1      ; write syscall
        syscall
        
get_value:
        mov rax, 42
        ret

add_5:
        mov rax, rdi
        add rax, 5
        ret

add:
        mov rax, rdi
        add rax, rsi
        ret

        section   .data   
hello:          db 'Hello', 10