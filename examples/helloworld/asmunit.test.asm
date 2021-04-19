
%include "asmunit.asm"

        global  main

        section .text
main:
    call before_all

    
    push test_assert_equals_fails_on_different_values
    push test_assert_equals_success_on_same_values
    push test_result_is_fail_when_one_assert_fails
    push 3

    call run_all_tests

    .remove_test_list_from_stack
        pop rax
        mov rdi, 8
        mul rdi
        add rsp, rax 
 
    mov rax, [all_tests_result]
    ret

run_all_tests:
    push rbp           
    mov rbp, rsp  

    
    ;pop rax    
    mov rax, [rbp+16+8*0]
    push rax
    
    .run_next_test
        pop rax
        mov [nb_tests_to_run], rax
        cmp rax, 0
        jle .after_all_tests

        call before_each

    .next_test_address
        mov rax, [nb_tests_to_run] 
        mov dx, 8
        mul dx

        add rax, rbp
        add rax, 16
        
        mov rax, [rax]

    .execute_next_test    

        call rax
        call after_each

        mov rax, [nb_tests_to_run]
        dec rax
        push rax

        jmp .run_next_test

    .after_all_tests:
        call after_all    
        leave
        ret

test_assert_equals_fails_on_different_values:
    mov rdi, 2
    mov rsi, 3
    call assert_equals
    mov [result], rax                ; assert_equals return  value
    
    call before_each 
    mov rdi, [result]
    mov rsi, 1                  ; expected value: 1 = false
    call assert_equals
    ret

test_assert_equals_success_on_same_values:
    mov rdi, 2
    mov rsi, 2
    call assert_equals
    mov [result], rax                ; assert_equals return  value
    
    call before_each    
    mov rdi, [result]
    mov rsi, 0                  ; expected value: 0 = true
    call assert_equals
    ret

test_result_is_fail_when_one_assert_fails:
    
    mov rdi, 2
    mov rsi, 3
    call assert_equals
    
    mov rdi, 2
    mov rsi, 2
    call assert_equals

    mov rdi, [one_test_result]  ; assert_equals return  value    
    mov rsi, 1                  ; expected value: 0 = true
    call before_each
    call assert_equals

    ret


fail:
    ret

    section   .data
result:  dq        8
nb_tests_to_run:  dq         0       ; nb tests to run