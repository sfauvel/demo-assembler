; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  calibration     ;
    global  sum_of_lines   ;
    global  sum_of_lines_timer   ;

    section .text

sum_of_lines_timer:
    push rsi
    rdtsc
    mov [duration], rax
    call sum_of_lines
    mov rbx, rax

    rdtsc
    sub rax, [duration]
    pop rsi
    mov [rsi], rax

    mov rax, rbx
    ret

sum_of_lines:
    mov dword[total], 0        ; Reinit total value

    .next_line:
        call calibration
        add rax, [total]
        mov [total], rax 
        cmp byte [rdx], 0
        je .finish
        inc rdx
        mov rdi, rdx
        jmp .next_line
    .finish:
        mov rax, [total]
        ret

calibration:
    mov rdx, rdi

    call go_to_next_number
    cmp al, '0'
    jl  .no_digit
    cmp al, '9'
    jg .no_digit


    mov bl, al

    .store_first:
        xor rax,rax
        mov al, [rdx]
        sub al, '0'
        mov cl, 10
        mul cl
        mov [value], rax
        mov al, [rdx]

    .next_number:
        mov bl, al
        inc rdx
        call go_to_next_number
        cmp al, 0
        je .finish
        cmp al, CARRIAGE_RETURN
        je .finish
        jmp .next_number

    .finish:
        mov al, bl
        sub al, '0'
        add rax, [value]
        
        ret

    .no_digit:
        mov rax, 0
        ret

go_to_next_number:
    mov al, [rdx]

    cmp al, 0
    je .finish
    cmp al, CARRIAGE_RETURN
    je .finish

    cmp al, '0'
    jl .next_char
    cmp al, '9'
    jg .next_char

    .finish:
        ret
        
    .next_char:
        inc rdx
        jmp go_to_next_number



    section   .data
value:        dq      0
total:        dq      0
duration:     dq      0
CARRIAGE_RETURN       equ    10