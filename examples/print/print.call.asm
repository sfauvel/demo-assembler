GLOBAL test_asm_println_between_text

extern print_text
extern print_ln

section .text

test_asm_println_between_text:
    mov rdi, message_open
    call print_text

    call print_ln

    mov rdi, message_close
    call print_text
    ret

section .data
message_open:      db ">>>",0
message_close:     db "<<<",0
