; -----------------------------------------------------------------------------
; Demo of comparator: jg, jl, je
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  if_greater_than_10           ;
        global  if_not_greater_than_10       ;
        global  if_greater_or_equal_than_10  ;
        global  if_lower_than_10             ;
        global  if_equals_10                 ;

        section .text
if_greater_than_10:
        cmp rdi,10        ; Compare rdi (first parameter) to 10
        jg return_true    ; Jump if comparison flag is set to greater
        jmp return_false  ; Incondition jump

if_not_greater_than_10:
        cmp rdi,10        ; Compare rdi (first parameter) to 10
        jng return_true   ; Jump if comparison flag is not set to greater
        jmp return_false  ; Incondition jump

if_greater_or_equal_than_10:
        cmp rdi,10        ; Compare rdi (first parameter) to 10
        jge return_true   ; Jump if comparison flag is set to greater or equal
        jmp return_false  ; Incondition jump
        
if_lower_than_10:
        cmp rdi,10
        jl return_true    ; Jump if comparison flag is set to lower
        jmp return_false

if_equals_10:
        cmp rdi,10
        je return_true    ; Jump if comparison flag is set to equal
        jmp return_false

return_false:
        mov rax, 0
        ret

return_true:
        mov rax, 1
        ret
