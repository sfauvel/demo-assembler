; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  loop_count_iteration     ;

    section .text
loop_count_iteration:
    mov rcx, rdi ; number of iterations
    mov rax, 0
    .next:
        inc rax
    loop .next ; rcx = rcx - 1, if rcx != 0, then jump to .next
    ret
