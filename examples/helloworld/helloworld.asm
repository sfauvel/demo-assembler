; -----------------------------------------------------------------------------
; Code retreat 2020.
;
; -----------------------------------------------------------------------------
        
        ; Define methods exported
        global  next_state_for     ;
        
        section .text
next_state_for:           
        cmp rdi, ALIVE
        jne is_dead

is_alive:
        cmp rsi, 2
        jl die

        cmp rsi, 3
        jg die

        jmp alive

is_dead:
        cmp rsi, 3
        jne die

alive:
        mov rax, ALIVE
        ret

die:
        mov rax, DEAD
        ret
                      
        section   .data   
ALIVE equ      'O'
DEAD  equ      'X'