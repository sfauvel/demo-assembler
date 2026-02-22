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
if_greater_than_10:
        cmp rdi,10        ; Compare rdi to 10
        jg return_true    ; Jump if comparison flag is set to greater
        jmp return_false

if_lower_than_10:
        cmp rdi,10
        jl return_true
        jmp return_false

if_equals_10:
        cmp rdi,10
        je return_true
        jmp return_false

return_false:
        mov rax, 0
        ret

return_true:
        mov rax, 1
        ret
