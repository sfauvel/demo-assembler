
        global display_stack
        global display_flags
        
        extern print_text
        extern print_number

            section .text
display_stack:

        
        mov rax, rdi
        mov rdx, rbp
        sub rdx, 5*8
        
    next_rsp:
        cmp rdx,rax
        je no_display
        
        push rax
        push rdx
        mov rdi, [rax]
        call print_number
        
        mov rdi, next_line
        call print_text  
        pop rdx
        pop rax
        
        add rax, 8
        jmp next_rsp


    no_display:
        ;mov rdi, new_line
        ;call print_text
        ret


; parameters
;   rsi: value
;   rdi: mask
display_one_flag:
    push rsi
    push rdi
    push rax
    mov rax, rsi   ; Get value to check
    and rax, rdi   ; Apply mask

    jz print_0
    jmp print_1
    print_0:
        mov rdi, 0
        call print_number
        jmp flags_continue
    print_1:
        mov rdi, 1
        call print_number
        jmp flags_continue
    flags_continue:
        pop rax
        pop rdi
        pop rsi
        ret

; parameters
;   rsi: flags
display_flags:
    push rsi
    push rdi

    mov rdi, 1 
    .display_next_flag:
    
        call display_one_flag
        shl rdi, 1

        cmp rdi, 1 << 17
        je  .end_of_display_flags
        jmp .display_next_flag

    .end_of_display_flags:

    pop rdi
    pop rsi
    ret

            section   .data
space      db       ' ', 0;
table      db       '|====', 0;
cell       db       ' a| ', 0;
new_line   db       10, 0;
next_line  db       ',', 0;