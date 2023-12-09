; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  calibration     ;

        section .text
calibration:
        mov rdx, rdi


continue_first:
        mov bl, [rdx]
        cmp bl, '0'
        jl next_first
        cmp bl, '9'
        jg next_first
        jmp store_first
        
next_first:
        inc rdx
        jmp continue_first
        
store_first:
        xor rax,rax
        mov al, [rdx]
        sub al, 48
        mov [value], rax

continue:
        inc rdx
        mov bl, [rdx]
        cmp bl, 0
        je finish 

        cmp bl, '0'
        jl continue
        cmp bl, '9'
        jg continue
        mov al, [rdx]
        
        jmp continue

finish:
        sub al, 48
        add rax, [value]

        ret

        section   .data
value:                db      0