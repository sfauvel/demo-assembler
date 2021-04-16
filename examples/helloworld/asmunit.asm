
    section .text

assert_equals:
    cmp rdi, rsi
    jne ae_fail

    ae_success:
        mov rax, 0
        jmp end_assert_equals

    ae_fail:
        mov rax, 1

    end_assert_equals:
        ret

before_all:
    mov rbx, 0
    ret

after_all:
    mov rax, rbx
    ret

before_each:
    ret

after_each:
    add rbx, rax
    call display_result
    ret

display_result:
    cmp       rax, 1
    je set_fail_message

    set_success_message:
        mov       rsi, message_success    ; address of string to output
        jmp       output_message

    set_fail_message:
        mov       rsi, message_failure    ; address of string to output
        jmp       output_message

    output_message:
        mov       rax, 1                  ; system call for write
        mov       rdi, 1                  ; file handle 1 is stdout
        mov       rdx, 1                 ; number of bytes
        syscall                           ; invoke operating system to do the write
        ret

    section   .data
message_success:  db        "."      ; note the newline at the end
message_failure:  db        "X"      ; note the newline at the end