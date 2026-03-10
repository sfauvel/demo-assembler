; -----------------------------------------------------------------------------
; An assembler program
; -----------------------------------------------------------------------------

        global  _start  ; Export start label

        section .text
_start:                 ; Label where the program start
say_hello:
        mov rsi, hello  ; String to print
        mov rdx, 6      ; How many character to print

print:
        mov rax, 1      ; sys_write
        mov rdi, 1      ; stdout 
        syscall

exit:   
        mov rax, 60     ; Exit sys call
        mov rdi, 0      ; Exit status code
        syscall

        section .data
hello:  db      "Hello", 10, 13, 0  ; 10 and 13 to carriage return. End with 0 unless string continue with the next one