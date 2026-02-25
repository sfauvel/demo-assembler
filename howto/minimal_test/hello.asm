; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        section .text

print:
        mov eax, 4      ; set sys_write syscall
        mov ebx, 1
        int 0x80

exit:   mov eax, 1 ; Exit sys call
        mov ebx, 0 ; Exit status code
        int 0x80

        section .data
hello:  db      "Hello", 10, 13, 0  ; 10 and 13 to carriage return. End with 0 unless string continue with the next one