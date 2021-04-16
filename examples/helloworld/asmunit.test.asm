
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

