; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  param_sum_param     ;

        section .text
param_sum_param:
        push rdx
        push rsi
        push rdi

        xor rbx, rbx

        pop rax
        mov rcx, 1
        mul rcx
        add rax, rbx
        mov rbx, rax

        pop rax
        mov rcx, 10
        mul rcx
        add rax, rbx
        mov rbx, rax
       
        pop rax
        mov rcx, 100
        mul rcx
        add rax, rbx
        mov rbx, rax
        
        mov rax, rbx
        ret
