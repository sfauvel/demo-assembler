; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define exported methods
    global  calibration_from_file
    global  calibration_from_buffer
    global  is_digit
    global  cmp_string

    extern compute_file

    SYS_EXIT  equ 1
    STDIN     equ 0
    STDOUT    equ 1
    END_OF_FILE           equ    0
    CARRIAGE_RETURN       equ    10

    BUFFER_LETTER_SIZE    equ    10

    section .text
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

cmp_string:
    mov r8, rdi  ; text
    mov r9, rsi  ; label
    mov r10, rsi
    mov rax, 0
    .to_the_end:
        inc rax
        mov r11b, [r10]
        inc r10
        cmp r11b, 0
        jne .to_the_end
        ; rax = label size
    
    mov rcx, 0
    .to_the_end_text:
        inc rcx
        mov r11b, [r8]
        inc r8
        cmp r11b, 0
        jne .to_the_end_text
        ; rax = text size

    cmp rcx, rax
    jl .not_equals
    sub r8, rax

    .start_cmp:
    mov al, [r8]
    cmp al, [r9]
    jne .not_equals
    
    cmp al, 0
    jne .next
    mov rax, 0
    ret

    .next:
    inc r8
    inc r9
    jmp .start_cmp
    
    .not_equals:
    mov rax, 1
    ret

; Param:
;   RDI: character
; Return:
;   RAX: O if a digit.
;   RBX: digit value
is_digit:
    xor rax, rax
    mov al, [rdi]
    cmp al, 0
    je .reset

    cmp al, '9'
    jg .not_a_digit 

    cmp al, '0'
    jl .not_a_digit
    
    sub rax, '0'
    ret

    .not_a_digit:
    cmp byte [digit_text_length], BUFFER_LETTER_SIZE
    jl .under_max
    mov byte [digit_text_length], 0

    .under_max:
    xor rbx, rbx
    mov bl, [digit_text_length]
    inc rbx
    mov [digit_text_length], bl

    mov rcx, digit_text
    add rcx, rbx
    
    mov byte [rcx], 0
    dec rcx
    mov [rcx], al
    

;    .check_0:
;    cmp byte [digit_text_length], 4
;    jne .check_1
;
;    cmp byte [digit_text], 'z'
;    jne .check_1
;    cmp byte [digit_text+1], 'e'
;    jne .check_1
;    cmp byte [digit_text+2], 'r'
;    jne .check_1
;    cmp byte [digit_text+3], 'o'
;    jne .check_1
;    mov rax, 0
;    ret

    .check_1:
    mov rdi, digit_text
    mov rsi, label_one
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_2
    mov rax, 1
    ret

    .check_2:
    mov rdi, digit_text
    mov rsi, label_two
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_3
    mov rax, 2
    ret

    .check_3:
    mov rdi, digit_text
    mov rsi, label_three
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_4
    mov rax, 3
    ret

    .check_4:
    mov rdi, digit_text
    mov rsi, label_four
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_5
    mov rax, 4
    ret

    .check_5:
    mov rdi, digit_text
    mov rsi, label_five
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_6
    mov rax, 5
    ret

    .check_6:
    mov rdi, digit_text
    mov rsi, label_six
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_7
    mov rax, 6
    ret

    .check_7:
    mov rdi, digit_text
    mov rsi, label_seven
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_8
    mov rax, 7
    ret

    .check_8:
    mov rdi, digit_text
    mov rsi, label_height
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .check_9
    mov rax, 8
    ret

    .check_9:
    mov rdi, digit_text
    mov rsi, label_nine
    push rax
    call cmp_string
    mov r8, rax
    pop rax
    cmp r8, 0
    jne .return_false
    mov rax, 9
    ret

    .return_false:
    mov rax, -1
    ret

    .reset:
    mov byte [digit_text_length], 0
    jmp .return_false

compute_character: 
    xor rax,rax
    mov al, [rdx]


    ; check end of line
    cmp al, CARRIAGE_RETURN ;It's faster to check first CARRIAGE_RETURN because there is more than END_OF_FILE.
    je .end_of_line
    cmp al, END_OF_FILE
    je .end_of_line
  
    ; check if is a digit
    mov rdi, rdx
    call is_digit
    cmp rax, -1
    je .finish

    .is_digit:
    mov [second_value], al

    cmp byte [is_second_value], 1
    jne .first ; Inverting the condition, there is less jumps
    ret    

    .first:
        mov cl, 10
        mul cl
        mov [value], al
        mov byte [is_second_value], 1
        ;jmp .finish
        ret


    .end_of_line:
        mov al, [value]
        add al, [second_value]
        mov [value], al

        add rax, [total]
        mov [total], rax
        mov byte [second_value], 0
        mov byte [is_second_value], 0
        mov byte [value], 0
       ; jmp .finish

    .finish:
        ret


    section   .data
is_second_value:    db      0
value:              db      0
second_value:       db      0
total:              dq      0
digit_text_length:  db      0
label_one:          db      "one", 0
label_two:          db      "two", 0
label_three:        db      "three", 0
label_four:         db      "four", 0
label_five:         db      "five", 0
label_six:          db      "six", 0
label_seven:        db      "seven", 0
label_height:       db      "height", 0
label_nine:         db      "nine", 0

    section   .bss
digit_text:    resb BUFFER_LETTER_SIZE
