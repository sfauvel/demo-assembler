; -----------------------------------------------------------------------------
; Can define several methods in the same file.
;
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  short_method
    global  measure_perf_short_method
    global  long_method
    global  measure_perf_long_method
    global  nested_third_calls
    global  measure_perf_and_return_short_method_duration

    ; Relative to the project path
    %include "../../examples/perf/perf.mac"

    section   .data

duration_value: dq      0
duration_param: dq      0

        section .text
measure_perf_short_method:
    mov [duration_param], rdi  ; First parameter is a reference to the long that will contain the duration

    MONITOR_EXECUTION short_method  ; Execute the method to monitor

    mov rbx, [duration_param]      ; Set the return parameter with duration value
    mov rcx, [duration_value]
    mov [rbx], rcx

    ret

measure_perf_long_method:
    mov [duration_param], rdi  ; First parameter is a reference to the long that will contain the duration

    MONITOR_EXECUTION long_method  ; Execute the method to monitor

    mov rbx, [duration_param]      ; Set the return parameter with duration value
    mov rcx, [duration_value]
    mov [rbx], rcx

    ret

measure_perf_and_return_short_method_duration:
    MONITOR_EXECUTION short_method  ; Execute the method to monitor
    mov rax, [duration_value]
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

