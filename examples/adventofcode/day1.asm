; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  calibration
    global  sum_of_lines_timer
    global  calibration_from_file
    global  calibration_from_buffer

    global  calibration_from_file_timer
    global  calibration_from_buffer_timer

    SYS_EXIT  equ 1
    STDIN     equ 0
    STDOUT    equ 1
    SYS_READ  equ 3
    SYS_WRITE equ 4
    SYS_OPEN  equ 5
    SYS_CLOSE equ 6
    END_OF_FILE           equ    0
    CARRIAGE_RETURN       equ    10
    
    %macro MONITOR_EXECUTION 1
        push rsi
        rdtsc
        mov [duration], rax
        call %1
        mov rbx, rax

        rdtsc
        sub rax, [duration]
        pop rsi
        mov [rsi], rax

        mov rax, rbx
        ret
    %endmacro


    section .text
calibration_from_file:
    mov rdx, rdi               ; Get filename
    mov dword[total], 0        ; Reinit total value

    call open_file
    mov [file_descriptor], rax

    .read_next_char:
        mov rax, SYS_READ       ;sys_read
        mov rbx, [file_descriptor]
        mov rcx, current_char   ;pointer to destination buffer
        mov rdx, 1              ;read one character
        int 80h

        ; At this point rax contains number of characters read
        cmp rax, 0
        je .eof

        ; Compute next character
        mov rdx, current_char
        call compute_character
        
        jmp .read_next_char

    .eof:
        mov rbx, [file_descriptor]
        call close_file

    .finish:
        mov rax, [total]
        ret

; Parameters:
;   RDX:    filename
; Return: 
;   RAX:    file descriptor
open_file:
    mov rax, SYS_OPEN        ;sys_open file with fd in ebx
    mov rbx, rdx             ;file to be read
    mov rcx, 0               ;O_RDONLY
    int 80h
    ret

close_file:
    mov rax, SYS_CLOSE    ;sys_close file
    int 80h
    ret

sum_of_lines_timer:
    MONITOR_EXECUTION calibration_from_buffer

calibration_from_file_timer:
    MONITOR_EXECUTION calibration_from_file

calibration_from_buffer_timer:
    MONITOR_EXECUTION calibration_from_buffer

calibration_from_buffer:
    mov rdx, rdi               ; Get buffer
    mov dword[total], 0        ; Reinit total value

    .read_next_char:
    
        call compute_character
        
        cmp byte [rdx], END_OF_FILE
        je .finish
        inc rdx
        
        jmp .read_next_char

    .finish:
        mov rax, [total]
        ret

reinit:
    mov byte [value], 0
    mov byte [second_value], 0
    mov byte  [is_second_value], 0
    ret

calibration:
    call reinit
    mov rdx, rdi

    .next_character:
        call compute_character
        cmp byte [rdx], 0
        je .finish
        cmp byte [rdx], CARRIAGE_RETURN
        je .finish

        inc rdx

        jmp .next_character

    .finish:
        mov al, [value]
        ret

compute_character:
    xor rax,rax
    mov al, [rdx]

    ; check end of line
    cmp al, END_OF_FILE
    je .end_of_line
    cmp al, CARRIAGE_RETURN
    je .end_of_line

    ; check if is a digit
    cmp al, '0'
    jl .finish
    cmp al, '9'
    jg .finish

    sub al, '0'
    mov [second_value], al

    cmp byte [is_second_value], 1
    je .finish

    .first:
        mov cl, 10
        mul cl
        mov [value], al
        mov byte [is_second_value], 1
        jmp .finish

    .end_of_line:
        mov al, [value]
        add al, [second_value]
        mov [value], al
        mov byte [second_value], 0

        add rax, [total]
        mov [total], rax
        mov byte [is_second_value], 0
        jmp .finish

    .finish:
        ret


    section   .data
is_second_value:    db     0
value:              db      0
second_value:       db      0
total:              dq      0
duration:           dq      0

current_length:  dq 0
buffer_head:     dq 0
file_descriptor: dq 0


    section .bss
current_char:    resb 1