; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define methods exported
    global  calibration     ;
    global  sum_of_lines   ;

    section .text

sum_of_lines: 
    call calibration
    add rax, [total]
    mov [total], rax 
    inc rdx
    mov rdi, rdx
    call calibration
    add rax, [total]
    mov [total], rax
    ret

calibration:
    mov rdx, rdi

    call go_to_next_number
    mov bl, al


store_first:
    xor rax,rax
    mov al, [rdx]
    sub al, '0'
    mov cl, 10
    mul cl
    mov [value], rax
    mov al, [rdx]

next_number:
    mov bl, al
    inc rdx
    call go_to_next_number
    cmp al, 0
    je finish_calibration
    cmp al, CARRIAGE_RETURN
    je finish_calibration
    jmp next_number

finish_calibration:
    mov al, bl
    sub al, '0'
    add rax, [value]
    
    ret

go_to_next_number:
    mov al, [rdx]
    cmp al, 0
    je search_finished
    cmp al, CARRIAGE_RETURN
    je search_finished

    cmp al, '0'
    jl next_char
    cmp al, '9'
    jg next_char

    search_finished:
        ret
        
    next_char:
        inc rdx
        jmp go_to_next_number



    section   .data
value:        dq      0
total:        dq      0
CARRIAGE_RETURN       equ    10