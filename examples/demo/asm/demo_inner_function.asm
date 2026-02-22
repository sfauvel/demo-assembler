; -----------------------------------------------------------------------------
; Can call a function and continue using returned value.
;
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  inner_function_return_543     ;
        global  inner_function_using_stack_return_658     ;
        global  inner_function_using_stack_return_764     ;

        section .text
inner_function_return_543:
        mov rdi, 3          ; first parameter to function
        mov rsi, 40         ; second parameter to function
        call my_function    ; call function
        add rax, 500        ; add 500 to returned value that is in in rax
        ret

my_function:
        mov rax, rdi
        add rax, rsi
        ret

inner_function_using_stack_return_658:
        ; pass parameters from right to left
        push 600                ; third parameter to function
        push 50                 ; second parameter to function
        push 4                  ; first parameter to function
        call my_function_with_stack_saving_ebp    ; call function
        add rsp, 8*3  ; Move stack head for 3 parameters (3*8)
        ; It can also be done using pop 3 times. 
        ret

my_function_with_stack_saving_ebp:
        push rbp            ; store stack base
        mov rbp, rsp        ; replace stack base by head
        ; rsp + 8 contains rbp pushed above
        ; rsp contains address of the instruction after the call
        mov rax, [rsp+16+8*0]   ; get first parameter 
        add rax, [rsp+16+8*0]   
        add rax, [rsp+16+8*1]   ; get second parameter 
        add rax, [rsp+16+8*2]   ; get third parameter 
        leave         ; restore rbp
        ret
        
inner_function_using_stack_return_764:
        ; pass parameters from right to left
        push 700                ; third parameter to function
        push 60                 ; second parameter to function
        push 2                  ; first parameter to function
        call my_function_with_stack    ; call function
        add rsp, 8*3  ; Move stack head for 3 parameters (3*8)
        ; It can also be done using pop 3 times. 
        ret

my_function_with_stack:
        mov rax, [rsp+8*1]
        add rax, [rsp+8*1]
        add rax, [rsp+8*2]
        add rax, [rsp+8*3]
        ret
