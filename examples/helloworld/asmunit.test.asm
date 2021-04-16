
%include "asmunit.asm"

        global  main

        section .text
main:
    mov rbx, 0

    call test_assert_equals_fails_on_different_values
    add rbx, rax
    call display_result

    call test_assert_equals_success_on_same_values
    add rbx, rax
    call display_result

    mov rax, rbx
    ret

test_assert_equals_fails_on_different_values:
    mov rdi, 1
    mov rsi, 2
    call assert_equals
    mov rdi, rax                ; assert_equals return  value

    mov rsi, 1                  ; expected value: 1 = false   
    call assert_equals    
    
    ret

test_assert_equals_success_on_same_values:
    mov rdi, 2
    mov rsi, 2
    call assert_equals
    mov rdi, rax                ; assert_equals return  value

    mov rsi, 0                  ; expected value: 0 = true
    call assert_equals  
    ret

display_result:   
    cmp       rax, 1
    je display_fail
    jmp display_success

    display_fail:
        mov       rax, 1                  ; system call for write
        mov       rdi, 1                  ; file handle 1 is stdout
        mov       rsi, message_failure    ; address of string to output
        mov       rdx, 1                 ; number of bytes
        syscall                           ; invoke operating system to do the write
        ret 
    
    display_success:
        mov       rax, 1                  ; system call for write
        mov       rdi, 1                  ; file handle 1 is stdout
        mov       rsi, message_success    ; address of string to output
        mov       rdx, 1                 ; number of bytes
        syscall                           ; invoke operating system to do the write
        ret 


    section   .data
message_success:  db        "."      ; note the newline at the end
message_failure:  db        "X"      ; note the newline at the end