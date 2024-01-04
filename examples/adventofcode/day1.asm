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
    END_OF_STRING         equ    0
    CARRIAGE_RETURN       equ    10

    BUFFER_LETTER_SIZE    equ    100 ; It's work with a lower value but this slightly impacts performance

    EQUALS      equ 0
    NOT_EQUALS  equ 1

    BIGGEST_NUMBER_NAME   equ    5 ; biggest number (eight)

    %macro CHECK_DIGIT_TEXT_FIXED_SIZE 3
        mov r10, [digit_text_length]
        cmp r10, %2 ; It seems to be faster to move to register and then compare instead of compare with `cmp word [digit_text_length], %2` and then move to register.
        jl return_not_equals

        mov r8, digit_text
        add r8, r10
        sub r8, %2  ; Hard code the size
        mov r9, %1
        call cmp_string_with_size_%2 ; Call specific method for a given number
        cmp rax, EQUALS ; Check if we need to return a value
        mov rax, %3     ; Set return value 
        je return
    %endmacro

    %macro CHECK_DIGIT_TEXT 3
        mov r8, digit_text
        mov r9, %1
        mov r10, [digit_text_length]
        mov r11, %2 ; Put parameter in r11. It's not conventional
        
        cmp r10, r11
        jl return_not_equals

        call cmp_string_with_size
        cmp rax, EQUALS ; Check if we need to return a value
        mov rax, %3     ; Set return value 
        je return
    %endmacro

    section .text

; You can jmp here to make a return
return:
    ret

; You can jmp here to make a return
return_not_equals:
    mov rax, -1
    ret

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
    
    mov rdi, r9
    call .get_size_and_move_to_the_end
    mov r11, rax ; label size

    mov rdi, r8
    call .get_size_and_move_to_the_end
    mov r10, rax ; text size
    cmp r10, r11
    jl .not_equals

    call cmp_string_with_size
    ret 

    ; Parameters:
    ;   RDI: Text
    ; Return:
    ;   RAX: size + 1 (with the EOL character)
    ; At the end, RDI is on the first 0 at the end of the string.
    .get_size_and_move_to_the_end:
        mov rcx, 0
        .to_the_end:
            mov al, [rdi]
            inc rdi
            inc rcx
            cmp al, END_OF_STRING
            jne .to_the_end
        mov rax, rcx
        ret
    
    .not_equals:
    mov rax, NOT_EQUALS
    ret


; Param:
;   R8 : Text
;   R9 : Label
; Return:
;   RAX: 0 if equals else 1
cmp_string_with_size_5:

    ; Start comparison between the two strings with a fixed size.
    mov al, [r8 + 4]
    cmp al, [r9 + 4]
    jne cmp_string_return_not_equals ; When [r8] and [r9] are equals, we continue to the next character.

cmp_string_with_size_4:
    mov al, [r8 + 3]
    cmp al, [r9 + 3]
    jne cmp_string_return_not_equals ; When [r8] and [r9] are equals, we continue to the next character.

cmp_string_with_size_3:
    mov al, [r8 + 2]
    cmp al, [r9 + 2]
    jne cmp_string_return_not_equals ; When [r8] and [r9] are equals, we continue to the next character.
    mov al, [r8 + 1]
    cmp al, [r9 + 1]
    jne cmp_string_return_not_equals ; When [r8] and [r9] are equals, we continue to the next character.
    mov al, [r8]
    cmp al, [r9]
    jne cmp_string_return_not_equals ; When [r8] and [r9] are equals, we continue to the next character.
    
cmp_string_return_equals:
    mov rax, EQUALS
    ret

cmp_string_return_not_equals:
    mov rax, NOT_EQUALS
    ret

cmp_string_with_size:
    add r8, r10
    sub r8, r11  ; Start from end minus label size.

    ; Start comparison between the two strings with a fixed size.
    .start_cmp:
    cmp r11, 0
    je .return_equals
    mov al, [r8]
    cmp al, [r9]
    je .next ; When [r8] and [r9] are equals, we continue to the next character.
    
    .not_equals:
    mov rax, NOT_EQUALS
    ret

    .next:
    inc r8
    inc r9
    dec r11
    jmp .start_cmp

    .return_equals:
    mov rax, EQUALS
    ret

; Param:
;   DIL: the character
; Return:
;   AL: digit found (-1 otherwise).
;   RBX: digit value
is_digit:
    mov al, dil
    cmp al, END_OF_STRING
    je .reset

    ; If the character is a digit, return it.
    cmp al, '9'
    jg .not_a_digit 

    cmp al, '0'
    jl .not_a_digit
    
    sub al, '0'
    ret               ; Return the digit for this character.

    .not_a_digit:
    ; Check if there is space in buffer to put another character.
    cmp qword [digit_text_length], BUFFER_LETTER_SIZE
    jl .under_max
    call .shift_text

    .under_max:
    mov rbx, [digit_text_length]
    inc rbx
    mov [digit_text_length], rbx

    ; Add character to the digit text
    lea rcx, [digit_text + rbx - 1]
    mov byte [rcx], al

    .check_digit_from_text:
    ; Need to be in length order to exit as soon as the length is not long enough.
    ; MACRO          Label,      Label size,   Value
    CHECK_DIGIT_TEXT_FIXED_SIZE label_one,   3,           1
    CHECK_DIGIT_TEXT_FIXED_SIZE label_two,   3,           2
    CHECK_DIGIT_TEXT_FIXED_SIZE label_six,   3,           6
    CHECK_DIGIT_TEXT_FIXED_SIZE label_four,  4,           4
    CHECK_DIGIT_TEXT_FIXED_SIZE label_five,  4,           5
    CHECK_DIGIT_TEXT_FIXED_SIZE label_nine,  4,           9
    CHECK_DIGIT_TEXT_FIXED_SIZE label_three, 5,           3
    CHECK_DIGIT_TEXT_FIXED_SIZE label_seven, 5,           7
    CHECK_DIGIT_TEXT_FIXED_SIZE label_eight, 5,           8
 
    .return_false:
    mov rax, -1
    ret

    .reset:
    mov qword [digit_text_length], 0
    jmp .return_false

    .shift_text:   ; This part modify RBX and RCX
    push rax
    mov rax, digit_text                                                 ; target at the beginning
    mov rcx, BIGGEST_NUMBER_NAME 
    .shift_next_char:
        mov bl, [rax + BUFFER_LETTER_SIZE - BIGGEST_NUMBER_NAME]  ; Value between the first character (0) and the beginning of text to shift
        mov byte [rax], bl
        inc rax
    loop .shift_next_char
    mov qword [digit_text_length], BIGGEST_NUMBER_NAME  ; reset text
    pop rax
    ret

; Params:
;   RDX: Pointer to the character
compute_character: 
    xor rax,rax
    mov al, [rdx]           ; Put character in AL

    ; check end of line
    cmp al, CARRIAGE_RETURN ;It's faster to check first CARRIAGE_RETURN because there is more than END_OF_FILE.
    je .end_of_line
    cmp al, END_OF_FILE
    je .end_of_line
  
    ; check if is a digit
    mov rdi, [rdx]
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
digit_text_length:  dq      0
label_one:          db      "one", 0
label_two:          db      "two", 0
label_three:        db      "three", 0
label_four:         db      "four", 0
label_five:         db      "five", 0
label_six:          db      "six", 0
label_seven:        db      "seven", 0
label_eight:        db      "eight", 0
label_nine:         db      "nine", 0

    section   .bss
digit_text:    resb BUFFER_LETTER_SIZE
