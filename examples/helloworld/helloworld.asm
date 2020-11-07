; -----------------------------------------------------------------------------
; Hello world.
;
; -----------------------------------------------------------------------------
        
        ; Define methods exported
        global  next_state_for     ;
        
        section .text
next_state_for:                
        cmp rdi, 'O'
        jne is_dead

is_alive:
        mov rax, 'O'
        ret

is_dead:
        cmp rsi, 3
        jne die
alive:
        mov rax, 'O'
        ret

die:
        mov rax, 'X'
        ret
                      
