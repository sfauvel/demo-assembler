; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  next_generation     ;

        section .text
next_generation:
        mov rax, 0
        ret


        section   .data


        section   .bss      