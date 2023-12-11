; -----------------------------------------------------------------------------
; Can define several methods in the same file.
;
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  short_method                ;
    global  measure_perf_short_method   ;
    global  long_method                 ;
    global  measure_perf_long_method    ;

    section   .data
duration:     dq      0

        section .text
measure_perf_short_method:
    push rdi             ; First parameter is a reference to a long
    rdtsc                ; Put timestamp counter to rax
    mov [duration], rax
    call short_method
    mov rbx, rax         ; Save value to return

    rdtsc                ; Get the new timestamp counter
    sub rax, [duration]  ; Calculate the duration
    pop rsi              ; Set the value to return
    mov [rsi], rax

    mov rax, rbx         ; Restore the value to return
    ret

measure_perf_long_method:
    push rdi             ; First parameter is a reference to a long
    rdtsc                ; Put timestamp counter to rax
    mov [duration], rax
    call long_method
    mov rbx, rax         ; Save value to return

    rdtsc                ; Get the new timestamp counter
    sub rax, [duration]  ; Calculate the duration
    pop rsi              ; Set the value to return
    mov [rsi], rax

    mov rax, rbx         ; Restore the value to return
    ret

short_method:
    mov rax, 42
    ret

long_method:
    mov rax, 1000
    
    .next_loop
        cmp rax, 0
        dec rax
        jne .next_loop

        mov rax, 56
        ret

    section   .data
fsdff:     dq      0