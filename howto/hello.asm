; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  _start

        section .text
_start:
        mov ecx, hello  ; Character to print
        mov edx, 6      ; How many character to print

print:
        mov eax, 4      ; set sys_write syscall
        mov ebx, 1
        int 0x80

exit:   mov eax, 1 ; Exit sys call
        mov ebx, 0 ; Exit status code
        int 0x80

        section .data
hello:  db      "Hello", 10, 13, 0  ; 10 and 13 to carriage return. End with 0 unless string continue with the next one