
        global display_stack
        
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
        mov rdi, new_line
        call print_text
        ret


            section   .data
space      db       ' ', 0;
table      db       '|====', 0;
cell       db       ' a| ', 0;
new_line   db       10, 0;
next_line  db       ' +',10, 0;