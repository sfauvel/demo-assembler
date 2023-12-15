; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define exported methods
    global  calibration_from_file
    global  calibration_from_buffer

    extern compute_file

    SYS_EXIT  equ 1
    STDIN     equ 0
    STDOUT    equ 1
    END_OF_FILE           equ    0
    CARRIAGE_RETURN       equ    10

; Parameters
;   rdi: filename
; Return
;   rax: total
calibration_from_file:
    mov dword[total], 0        ; Reinit total value

    mov rdx, rdi               ; Get filename
    mov rsi, compute_character
    call compute_file
    
    mov rax, [total]
    ret



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

compute_character:
    xor rax,rax
    mov al, [rdx]

    ; check end of line
    cmp al, CARRIAGE_RETURN ;It's faster to check first CARRIAGE_RETURN because there is more than END_OF_FILE.
    je .end_of_line
    cmp al, END_OF_FILE
    je .end_of_line

    ; check if is a digit
    cmp al, '9' ; It's faster to ckech character greater then '9' because letters are greater than number in ascii table.
    jg .finish
    cmp al, '0'
    jl .finish

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
        mov byte [value], 0
        jmp .finish

    .finish:
        ret


    section   .data
is_second_value:    db     0
value:              db      0
second_value:       db      0
total:              dq      0
