
global do_nothing
global empty_loop
global loop_of_1000
global call_do_nothing_1000_loop
global call_do_nothing_1000_manual_loop
global jmp_do_nothing_1000_loop
global jmp_if_else_1000_loop
global cmp_rax_1000_loop
global cmp_al_1000_loop
global cmp_rdi_1000_loop
global cmp_value_1000_loop
global register_mov_1000_loop
global variable_mov_1000_loop

    section .text
; Use to have a reference
do_nothing:
    ret

; Use to have a reference
empty_loop:
    mov rcx, 1 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        ; do_nothing
    loop .next ; rcx = rcx - 1, if rcx !=
    ret

loop_of_1000:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        ; do_nothing
    loop .next ; rcx = rcx - 1, if rcx !=
    ret

call_do_nothing_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        call do_nothing
    loop .next ; rcx = rcx - 1, if rcx !=
    ret

call_do_nothing_1000_manual_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        call do_nothing
        dec rcx
        cmp rcx, 0
        jne .next
    ret

jmp_do_nothing_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        jmp .do_nothing
        .do_nothing:
            ; do nothing
    loop .next ; rcx = rcx - 1, if rcx !=
    ret

jmp_if_else_1000_loop:
    mov rax, rdi
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        cmp rax, 1  ; It's less performant when jump to .do_if because the .do_else instruction is prepared but not used.
        je .do_if ; If 
        .do_else:
            mov rbx, 20 ; Else
            jmp .end
        .do_if:
            mov rbx, 3
            jmp .end
        .end:
    loop .next ; rcx = rcx - 1, if rcx !=
    ret


cmp_rax_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        mov rax, 42
        cmp rax, 1
        je .finish
        mov rax, 0
    loop .next ; rcx = rcx - 1, if rcx !=
    .finish:
    ret

cmp_al_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        mov rax, 42
        cmp al, 1
        je .finish
        mov rax, 0
    loop .next ; rcx = rcx - 1, if rcx !=
    .finish:
    ret

cmp_rdi_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        mov rdi, 42
        cmp rdi, 1
        je .finish
        mov rdi, 0
    loop .next ; rcx = rcx - 1, if rcx !=
    .finish:
    ret

cmp_value_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        mov qword [value], 42
        mov rax, 42
        ; Uncomment one of the two lines below to select behavior to test
        ;cmp rax, 1
        cmp qword [value], 1
        je .finish
        mov rax, 0
        mov qword [value], 0
    loop .next ; rcx = rcx - 1, if rcx !=
    .finish:
    ret

register_mov_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        mov rax, 123 ; Need to change value to avoid some use of cache.
        mov [value], rax
        mov rax, [value]
        mov rax, 0
    loop .next ; rcx = rcx - 1, if rcx !=
    ret

variable_mov_1000_loop:
    mov rcx, 1001 ; RCX must be greater than 1 it not exit from loop (0-1 != 0)
    .next:
        mov rax, 123 ; Need to change value to avoid some use of cache.
        mov rbx, rax
        mov rax, rbx
        mov rax, 0
    loop .next ; rcx = rcx - 1, if rcx !=
    ret

    section .data
value   dq  0