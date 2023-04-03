; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  add_5     ;

        section .text
add_5:
        mov rax, rdi
        call something
        add rax, 5
        ret

something:
        push rax
        mov rax, 999
        pop rax
        ret

        section   .data