 ; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

default rel

        ; Define methods exported
        global  say_hello     ;
        global  get_hello     ;
        global  get_value     ;
        global  add_5         ;
        global  add           ;

        section .text

say_hello:
        mov rdi, 1      ; stdout fd (BF 01)
        lea rsi, [hello]
        mov rdx, 12      ; 11 chars + newline (BA 12)
        mov rax, 1      ; write syscall (B8 01)
        syscall         ; (0F 05)
        
get_hello:        
        lea rdi, [hello]
        lea rsi, [output]
        
        .continue_copy:
                mov al, [rdi]
                mov [rsi], al
                test al,al
                jz .found_zero_bit
                
                inc rdi
                inc rsi
        jmp .continue_copy
        
        .found_zero_bit:
        lea rax, [output]
        ret

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
hello:          db 'Hello world', 10, 0

        section   .bss        
output: resb         8*6                     ; Store output to return