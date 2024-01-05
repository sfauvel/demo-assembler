; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------

    ; Define exported methods
    global  calibration_from_file
    global  calibration_from_buffer
    global  is_digit

    extern compute_file
    extern print_number
    extern print_syscall

    SYS_EXIT  equ 1
    STDIN     equ 0
    STDOUT    equ 1
    END_OF_FILE           equ    0
    END_OF_STRING         equ    0
    CARRIAGE_RETURN       equ    10

    EQUALS      equ 0
    NOT_EQUALS  equ 1

        %macro PRINT_MSG 2
            push rdx
            push rsi
            mov rsi, %1   ; message to write
            mov rdx, %2   ; message length do not include the last 0
            call print_syscall
            pop rdx
            pop rsi
        %endmacro

        ; PRINT unitl 8 characters contain in a memory address (64 bits)
        %macro PRINT 1
                push rdi
                mov rdi, %1
                mov [tmp_text], rdi
                pop rdi
        ;        PRINT_MSG tmp_text, 8
        %endmacro

        %macro PRINTLN 1
                PRINT %1
        ;        PRINT_MSG carriage_return, 1
        %endmacro

        ; Print the value of a register or a variable
        ;    PRINT_NUMBER rax
        ;    PRINT_NUMBER [text_as_number]
        %macro PRINT_NUMBER 1
                push rbp
                push rax
                push rbp
                mov rax, %1
                call print_number
                pop rbp
                pop rax
                pop rbp
        %endmacro


    %macro CHECK_DIGIT_TEXT_FIXED_SIZE 2
        cmp r10, [%1]
        mov rax, %2     ; Set return value 
        je .return_value

    %endmacro

    %macro SHRINK_TO_LENGTH 2
        shl %1, 8*(8-%2); Remove %2 characters moving to the right then to the left
        shr %1, 8*(8-%2)
    %endmacro

    section .text

; Parameters
;   rdi: filename
; Return
;   rax: total
calibration_from_file:
    call init

    mov rdx, rdi               ; Get filename
    mov rsi, compute_character
    call compute_file
    
    mov rax, [total]
    ret

calibration_from_buffer:
    mov rdx, rdi               ; Get buffer
    call init

    .read_next_char:
    
        call compute_character
        
        cmp byte [rdx], END_OF_FILE
        je .finish
        inc rdx
        
        jmp .read_next_char

    .finish:
        mov rax, [total]
        ret

init:
    mov dword[total], 0        ; Reinit total value
    mov qword[text_as_number], 0
    ; Continue to call reinit

reinit:
    mov byte [first_value], 0
    mov byte [second_value], 0
    mov byte [is_second_value], 0
    ret


; Param:
;   DIL: the character (DIL is the lower bits of RDI)
; Return:
;   AL: digit found (-1 otherwise).
;   RBX: digit value
is_digit:
    mov al, dil
    cmp al, END_OF_STRING
    je .return_false

    ; If the character is a digit, return it.
    cmp al, '9'
    jg .not_a_digit 

    cmp al, '0'
    jl .not_a_digit
    
    sub al, '0'
    ret               ; Return the digit for this character.

    .not_a_digit:
    shl qword [text_as_number], 8 ; Shift bits to add the value of then new character
    add [text_as_number], al

    mov r10, [text_as_number]
    ; Need to remove first 5 characters and then 4 and then 3.
    SHRINK_TO_LENGTH r10, 5
            ;        PRINTLN r10
    ; MACRO                     Label,         Value
    CHECK_DIGIT_TEXT_FIXED_SIZE label_three,   3
    CHECK_DIGIT_TEXT_FIXED_SIZE label_seven,   7
    CHECK_DIGIT_TEXT_FIXED_SIZE label_eight,   8

    SHRINK_TO_LENGTH r10, 4
            ;        PRINTLN r10
    ; MACRO                     Label,         Value
    CHECK_DIGIT_TEXT_FIXED_SIZE label_four,   4
    CHECK_DIGIT_TEXT_FIXED_SIZE label_five,   5
    CHECK_DIGIT_TEXT_FIXED_SIZE label_nine,   9

    SHRINK_TO_LENGTH r10, 3
            ;        PRINTLN r10
    ; MACRO                     Label,         Value
    CHECK_DIGIT_TEXT_FIXED_SIZE label_one,    1
    CHECK_DIGIT_TEXT_FIXED_SIZE label_two,    2
    CHECK_DIGIT_TEXT_FIXED_SIZE label_six,    6
 
    .return_false:
    mov rax, -1
    ret

     .return_value:
    ret

; Params:
;   RDX: Pointer to the character
compute_character: 
    xor rax,rax
    mov al, [rdx]           ; Put character in AL

    ; check end of line
    cmp al, CARRIAGE_RETURN ;It's faster to check first CARRIAGE_RETURN because there is more than END_OF_FILE.
    je .compute_line
    cmp al, END_OF_FILE
    je .compute_line

    ; check if is a digit
    mov dil, al
    call is_digit
    cmp rax, -1
    je .finish

    .is_digit:
    mov [second_value], al

    cmp byte [is_second_value], 1
    jne .first ; Inverting the condition, there is less jumps
    ret    

    .first:
        mov [first_value], al
        mov byte [is_second_value], 1
        ret

    .compute_line:
        mov al, [first_value]
        mov cl, 10
        mul cl
        add al, [second_value]

        add rax, [total]
        mov [total], rax
        mov byte [first_value], 0
        mov byte [second_value], 0
        mov byte [is_second_value], 0
        ret

    .finish:
        ret

    section   .data
text_as_number:     dq      0
is_second_value:    db      0
first_value:        db      0
second_value:       db      0
total:              dq      0

; Labels need to be 8 characters to be compare with an 8 characters string.
; Lable is written in reverse order because the reading string push to the write characters read.
label_one:          db      "eno",   0,0,0,0,0
label_two:          db      "owt",   0,0,0,0,0
label_three:        db      "eerht", 0,0,0
label_four:         db      "ruof",  0,0,0,0
label_five:         db      "evif",  0,0,0,0
label_six:          db      "xis",   0,0,0,0,0
label_seven:        db      "neves", 0,0,0,0,0
label_eight:        db      "thgie", 0,0,0,0,0
label_nine:         db      "enin",  0,0,0,0

carriage_return:    db  0xa, 0
tmp_text:           dq      0
