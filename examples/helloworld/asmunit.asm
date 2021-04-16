
    
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