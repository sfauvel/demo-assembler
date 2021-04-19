
%include "asmunit.asm"

        global  main

        section .text
main:
    push test_assert_equals_fails_on_different_values
    push test_assert_equals_success_on_same_values
    push test_result_is_fail_when_one_assert_fails
    push 3

    call run_all_tests

    call remove_test_list_from_stack

    mov rax, [all_tests_result]
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
