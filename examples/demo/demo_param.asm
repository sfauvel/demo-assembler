; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  param_sum_param     ;

        section .text
param_sum_param:
        push rdx ; Third
        push rsi ; Second
        push rdi ; First

        mov rcx, 10
        xor rax, rax

        ; First
        mul rcx
        pop rdx
        add rax, rdx

        ; Second
        mul rcx
        pop rdx
        add rax, rdx

        ; Thord
        mul rcx
        pop rdx
        add rax, rdx

        ret