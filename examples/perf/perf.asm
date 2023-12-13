; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------
        
        global run_perf_with_parameter ; Pass as first parameter the variable with timestamp counter to return. 
        global run_perf_return_value   ; Return the timestamp counter.


        %include "perf.mac"

    section   .data

duration_value: dq      0
duration_param: dq      0

    section .text

run_perf_return_value:

    MONITOR_EXECUTION method_to_monitor

    mov     rax, [duration_value]
    ret 

run_perf_with_parameter:
    mov [duration_param], rdi

    MONITOR_EXECUTION method_to_monitor

    mov     rbx, [duration_param]      ; Set the return parameter with duration value
    mov     rcx, [duration_value]
    mov     [rbx], rcx
    ret

method_to_monitor:
    
    mov rcx, 10 ; number of iterations
    mov rax, 0
    .next:
        inc rax
    loop .next ; rcx = rcx - 1, if rcx != 0, then jump to .next
    ret
