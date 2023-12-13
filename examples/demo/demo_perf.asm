; -----------------------------------------------------------------------------
; Can define several methods in the same file.
;
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  short_method                ;
    global  measure_perf_short_method   ;
    global  long_method                 ;
    global  measure_perf_long_method    ;

    %macro MONITOR_EXECUTION 1
        push rax
        rdtsc                ; Put timestamp counter to rax
        mov [duration_value], rax
        pop rax

        call %1

        push rax
        rdtsc                ; Get the new timestamp counter
        sub rax, [duration_value]  ; Calculate the duration
        mov [duration_value], rax
        pop rax
    %endmacro

    section   .data
duration_value: dq      0
duration_param: dq      0

        section .text
measure_perf_short_method:
    mov [duration_param], rdi  ; First parameter is a reference to the long that will contain the duration
    
    MONITOR_EXECUTION short_method  ; Execute the method to monitor

    push rax
    push rbx
    mov rbx, [duration_param]      ; Set the return parameter with duration value
    mov rax, [duration_value]
    mov [rbx], rax
    pop rbx
    pop rax

    ret

measure_perf_long_method:
    mov [duration_param], rdi  ; First parameter is a reference to the long that will contain the duration
    
    MONITOR_EXECUTION long_method  ; Execute the method to monitor

    push rax
    push rbx
    mov rbx, [duration_param]      ; Set the return parameter with duration value
    mov rax, [duration_value]
    mov [rbx], rax
    pop rbx
    pop rax

    ret

short_method:
    mov rax, 42
    ret

long_method:
    mov rax, 1000
    
    .next_loop:
        dec rax
        cmp rax, 0
        jne .next_loop

        mov rax, 56
        
    ret
