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

        xor rax,rax
        mov al, [rdx]
        sub al, 48
        mov [value], rax

continue:
        mov bl, [rdx]
        cmp bl, 0
        je finish 

        mov al, [rdx]
        inc rdx
        jmp continue

finish:
        sub al, 48
        add rax, [value]

        ret

        section   .data
value:                db      0