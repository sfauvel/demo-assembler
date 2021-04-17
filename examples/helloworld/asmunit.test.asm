
%include "asmunit.asm"

        global  main

        section .text
main:
    call before_all

    
    push test_assert_equals_fails_on_different_values
    push test_assert_equals_success_on_same_values
    push test_result_is_fail_when_one_assert_fails
    push 3

    ;call run_all_tests
    ;ret

run_all_tests:
    pop rax    
    mov [nb_tests_to_run], rax
    cmp rax, 0
    jle after_all_tests

    call before_each
    pop rax
    call rax
    call after_each

    mov rax, [nb_tests_to_run]
    dec rax
    push rax
    jmp run_all_tests

    after_all_tests:
        call after_all    
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