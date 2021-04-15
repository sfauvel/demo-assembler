; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  param_sum_param     ;

        section .text
param_sum_param:
        mov rax, rdi
        add rax, rsi
        add rax, rdx
        ret
