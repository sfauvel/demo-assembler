; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  set_unset_value
        global  set_value_init_to_0

        section .text
set_unset_value:
        mov [value_unset], rdi                ; set parameter (rdi) to [value]
        mov rax, [value_unset]                ; return value
        ret

set_value_init_to_0:
        mov [value_set_to_0], rdi                ; set parameter (rdi) to [value]
        mov rax, [value_set_to_0]                ; return value
        ret

        section .data
value_set_to_0:      db      0        ; Value set to 0
value_unset:         resb    4        ; Value without value (4 bytes)