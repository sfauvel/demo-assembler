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

        call go_to_next_number
        mov bl, al


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

go_to_next_number:
        mov al, [rdx]
        cmp al, '0'
        jl next_char
        cmp al, '9'
        jg next_char
        ret
        
next_char:
        inc rdx
        jmp go_to_next_number



        section   .data
value:                db      0