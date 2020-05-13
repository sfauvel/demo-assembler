; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  set_unset_value
        global  set_value_init_to_0

        global  return_first_64_bits_int
        global  return_first_unsigned_int
        global  add_to_stack

        section .text
set_unset_value:
        mov [value_unset], rdi                ; set parameter (rdi) to [value]
        mov rax, [value_unset]                ; return value
        ret

set_value_init_to_0:
        mov [value_set_to_0], rdi                ; set parameter (rdi) to [value]
        mov rax, [value_set_to_0]                ; return value
        ret

return_first_unsigned_int:
        mov [first_int],    di                
        mov [second_int],   si              
        mov ax, [first_int]                ; return value
        ret

return_first_64_bits_int:
        mov [first_int64],    rdi                
        mov [second_int64],   rsi              
        mov rax, [first_int64]                ; return value
        ret

add_to_stack:
        add [stored_value],    rdi  
        mov rax, [stored_value]                ; return value
        ret

        section .data
value_set_to_0:         db      0        ; Value set to 0

stored_value:           db     0         ; Value without value (2 bytes)

        section .bss
value_unset:            resb    8        ; Value without value (4 bytes)

; resb with 8 for a 64 bits integer
first_int64:            resb    8        ; Value without value (8 bytes). If we use 4, space is not enough to store an integer 64 bits
second_int64:           resb    8        ; Value without value (8 bytes)

; resb with 2 for an unsigned integer
first_int:              resb    2        ; Value without value (2 bytes)
second_int:             resb    2        ; Value without value (2 bytes)
