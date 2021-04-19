

    section .text

assert_equals:
    cmp rdi, rsi
    jne assert_equals_fail

    assert_equals_success:
        mov rax, 0
        jmp assert_equals_end

    assert_equals_fail:
        mov rax, 1
        mov [one_test_result], rax

    assert_equals_end:
        ret

run_all_tests:
    push rbp
    mov rbp, rsp

    mov rax, [rbp+16+8*0]
    push rax

    .run_next_test:
        pop rax
        mov [nb_tests_to_run], rax
        cmp rax, 0
        jle .after_all_tests

        call before_each

    .next_test_address:
        mov rax, [nb_tests_to_run]
        mov dx, 8
        mul dx

        add rax, rbp
        add rax, 16

        mov rax, [rax]

    .execute_next_test:

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

before_all:
    mov rax, 0
    mov [all_tests_result], rax
    ret

after_all:
    mov rax, [all_tests_result]
    ret

before_each:
    mov rax, 0
    mov [one_test_result], rax
    ret

after_each:
    mov rax, [one_test_result]
    add [all_tests_result], rax
    mov rdi, [one_test_result]
    call display_result
    ret



display_result:
    cmp       rdi, 1
    jge set_fail_message

    set_success_message:
        mov       rsi, message_success    ; address of string to output
        jmp       output_message

    set_fail_message:
        mov       rsi, message_failure    ; address of string to output
        jmp       output_message

    output_message:
        mov       rax, 1                  ; system call for write
        mov       rdi, 1                  ; file handle 1 is stdout
        mov       rdx, 1                  ; number of bytes
        syscall                           ; invoke operating system to do the write
        ret

    section   .data
message_success:  db        "."      ; note the newline at the end
message_failure:  db        "X"      ; note the newline at the end
all_tests_result: dq         8       ; global result of execution
one_test_result:  dq         8       ; result of one test
nb_tests_to_run:  dq         0       ; nb tests to run