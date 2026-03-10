; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  say_hello  ; Export start label

        section .text
say_hello:
        mov rsi, hello  ; String to print
        mov rdx, 6      ; How many character to print

print:
        mov rax, 1      ; sys_write
        mov rdi, 1      ; stdout 
        syscall

exit:   
        ret

        section .data
hello:  db      "Hello", 10, 13, 0  ; 10 and 13 to carriage return. End with 0 unless string continue with the next one