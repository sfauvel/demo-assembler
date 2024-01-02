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

    BUFFER_LETTER_SIZE    equ    20

    EQUALS      equ 0
    NOT_EQUALS  equ 1

    BIGGEST_NUMBER_NAME   equ    5 ; biggest number (eight)

    %macro CHECK_DIGIT_TEXT 2
        mov rdi, digit_text
        mov rsi, %1
        call cmp_string
        cmp rax, EQUALS ; Check if we need to return a value
        mov rax, %2     ; Set return value 
        je return
    %endmacro

    section .text

; You can jmp here to make a return
return:
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


; Param:
;   RDI: Text
;   RSI: Label
; Return:
;   RAX: 0 if equals else 1
cmp_string:
    mov r8, rdi  ; text
    mov r9, rsi  ; label
    
    mov rdi, r9
    call .get_size_and_move_to_the_end
    mov r10, rax ; label size

    mov rdi, r8
    call .get_size_and_move_to_the_end
    mov r11, rax ; text size

    cmp r11, r10
    jl .not_equals
    mov r8, rdi
    sub r8, r10  ; Start from end minus label size.

    ; Start comparison between the two strings.
    .start_cmp:
    mov al, [r8]
    cmp al, [r9]
    jne .not_equals ; When [r8] and [r9] are not equals, we can return 1.
    
    cmp al, END_OF_STRING
    jne .next   ; When [r8] and [r9] are equals but not to 0, we need to continue.
    mov rax, EQUALS
    ret

    .next:
    inc r8
    inc r9
    jmp .start_cmp
    
    .not_equals:
    mov rax, NOT_EQUALS
    ret

    ; Parameters:
    ;   RDI: Text
    ; Return:
    ;   RAX: size + 1 (with the EOL character)
    ; At the end, RDI is on the first 0 at the end of the string.
    .get_size_and_move_to_the_end:
        mov rcx, 0
        .to_the_end:
            inc rcx
            mov al, [rdi]
            inc rdi
            cmp al, END_OF_STRING
            jne .to_the_end
        mov rax, rcx
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
    cmp byte [digit_text_length], BUFFER_LETTER_SIZE
    jl .under_max
    call .shift_text

    .under_max:    
    xor rbx, rbx  ; Needed to add the value to digit_text below.
    mov bl, [digit_text_length]
    inc bl
    mov [digit_text_length], bl

    ; Add character to the digit text and put a 0 after it
    lea rcx, [digit_text + rbx]
    mov byte [rcx]    , END_OF_STRING
    mov byte [rcx - 1], al

    .check_digit_from_text:
    CHECK_DIGIT_TEXT label_one,   1
    CHECK_DIGIT_TEXT label_two,   2
    CHECK_DIGIT_TEXT label_three, 3
    CHECK_DIGIT_TEXT label_four,  4
    CHECK_DIGIT_TEXT label_five,  5
    CHECK_DIGIT_TEXT label_six,   6
    CHECK_DIGIT_TEXT label_seven, 7
    CHECK_DIGIT_TEXT label_eight, 8
    CHECK_DIGIT_TEXT label_nine,  9
 
    .return_false:
    mov rax, -1
    ret

    .reset:
    mov byte [digit_text_length], 0
    jmp .return_false

    .shift_text:
    push rax
    push rbx
    mov rax, digit_text                                                 ; target at the beginning
    mov rcx, BIGGEST_NUMBER_NAME 
    .shift_next_char:        
        mov bl, [rax + BUFFER_LETTER_SIZE - BIGGEST_NUMBER_NAME]  ; Value between the first character (0) and the beginning of text to shift
        mov byte [rax], bl
        inc rax        
    loop .shift_next_char
    mov byte [digit_text_length], BIGGEST_NUMBER_NAME  ; reset text
    pop rbx
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
digit_text_length:  db      0
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
