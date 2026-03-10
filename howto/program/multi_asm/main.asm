; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  _start  ; Export start label
        extern  say_hello: function

        section .text
_start:                 ; Label where the program start
        call say_hello

exit:
        mov rax, 60     ; Exit sys call
        mov rdi, 0      ; Exit status code
        syscall

        section .data
hello:  db      "Hello", 10, 13, 0  ; 10 and 13 to carriage return. End with 0 unless string continue with the next one