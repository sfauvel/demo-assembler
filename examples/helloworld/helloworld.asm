; -----------------------------------------------------------------------------
; Hello world.
;
; -----------------------------------------------------------------------------
        
        ; Define methods exported
        global  next_state_for     ;
        
        section .text
next_state_for:        
        mov rax, rsi
        cmp rsi, 'O'
        jne is_dead

is_alive:
        mov rax, 'O'
        ret
        
is_dead:
        cmp rdi, 3
        jne die
alive:
        mov rax, 'O'
        ret

die:
        mov rax, 'X'
        ret
                      
