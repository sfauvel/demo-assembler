; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  next_generation     ;
        global  board               ;
        global  set_alive           ;

        section .text

; 1-RDI: neighbor
; 2-RSI: state
next_generation:
        cmp rdi, 4
        jge .die
        cmp rdi, 2
        jl .die
        cmp rdi, 2
        je .twoNeighbors
        mov rax, 1
        ret

        .die: 
                mov rax, 0
                ret
        
        .twoNeighbors:
                mov rax, rsi
                ret


board:
        mov rax, buffer
        ret

set_alive:
        mov byte [buffer + 5], '*'
        ret

;;; DATA
section   .data

buffer:  db   '   ',10,'   ',10,'   ', 0;

        section   .bss
;buffer:  resb   100;