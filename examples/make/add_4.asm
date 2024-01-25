; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  add_4     ;

        section .text
add_4:
        mov rax, rdi
        call something
        add rax, 4
        ret

something:
        push rax
        mov rax, 999
        pop rax
        ret

        section   .data