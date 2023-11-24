        global test_1_push
        global test_3_push
        global test_reinit_current_stack_head

        extern display_stack
        extern show_value

section .text

test_1_push:
        push    rbp 
        mov     rbp,rsp 

        push 101

        call display_stack
        
        pop rax

        mov     rsp,rbp 
        pop     rbp

        ret

test_3_push:
        push 101
        push 102
        push 103

        call display_stack
        
        pop rax
        pop rax
        pop rax
        
        ret

test_reinit_current_stack_head:
        push    rbp 
        mov     rbp,rsp 

        push 101        
        push 102

        call display_stack
        
        pop rax
        pop rax

        mov     rsp,rbp 
        pop     rbp

        ret