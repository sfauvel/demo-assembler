; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  if_greater_than_10     ;
        global  if_lower_than_10       ;
        global  if_equals_10           ;

        section .text

                        ; tag::if_greater_than_10[]
if_greater_than_10:
        cmp rdi,10        ; Compare rdi to 10
        jg return_true    ; Jump if comparison flag is set to greater
        jmp return_false
                        ; end::if_greater_than_10[]
                        ; tag::if_lower_than_10[]
if_lower_than_10:
        cmp rdi,10
        jl return_true
        jmp return_false
                        ; end::if_lower_than_10[]
                        ; tag::if_equals_10[]
if_equals_10:
        cmp rdi,10
        je return_true
        jmp return_false
                        ; end::if_equals_10[]
                        ; tag::common[]
return_false:
        mov rax, 0
        ret

return_true:
        mov rax, 1
        ret
                        ; end::common[]