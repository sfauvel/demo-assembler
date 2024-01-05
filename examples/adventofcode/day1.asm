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

    BUFFER_LETTER_SIZE    equ    1000 ; It's work with a lower value but this slightly impacts performance

    EQUALS      equ 0
    NOT_EQUALS  equ 1

    BIGGEST_NUMBER_NAME   equ    5 ; biggest number (eight)

        %macro PRINT_X 2

            ;push rdx
            ;push rsi
            ;mov rsi, %1   ; message to write using the stack address
            ;mov rdx, %2   ; message length do not include the last 0
            ;call print_syscall
            ;pop rdx
            ;pop rsi

                push rax
                push rbx
                push rcx
                push rdi
                push rdx
                push rsi
                push r9
                push r10
                push r11
                
                mov rsi, %1   ; message to write using the stack address
                mov rdx, %2   ; message length do not include the last 0
                mov rdi, 1   ; file descriptor: 1 = STDOUT
                mov rax, 1   ; system call number (sys_write)
                syscall
                pop r11
                pop r10
                pop r9
                pop rsi
                pop rdx
                pop rdi
                pop rcx
                pop rbx
                pop rax
        %endmacro

        %macro PRINT_MSG 2
            ;    PRINT_X %1, %2
        %endmacro

        %macro PRINT 1
                push rdi
                mov rdi, %1
                mov [tmp_text], rdi
                pop rdi
            ;    PRINT_X tmp_text, 8
        %endmacro

        %macro PRINTLN 1
                PRINT %1
            ;    PRINT_MSG carriage_return, 1
        %endmacro

        %macro PRINT_NUMBER 0
                push rbp
                call print_number
                pop rbp
        %endmacro


    %macro CHECK_DIGIT_TEXT_FIXED_SIZE 2
        cmp r10, [%1]
        mov rax, %2     ; Set return value 
        je .return_value

    %endmacro

    section .text


; You can jmp here to make a return
return_not_equals:
    mov rax, -1
    ret

; Parameters
;   rdi: filename
; Return
;   rax: total
calibration_from_file:
    call init

    mov rdx, rdi               ; Get filename
    mov rsi, compute_character
    call compute_file
    
    ;mov rdi, end_message
    ;call print_text

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
    mov byte [value], 0
    mov byte [second_value], 0
    mov byte [is_second_value], 0
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
    shl r10, 8*(8-5); Remove 3 characters moving to the right then to the left
    shr r10, 8*(8-5)
                ;    PRINTLN r10
    ; MACRO                     Label,         Value
    CHECK_DIGIT_TEXT_FIXED_SIZE label_three,   3
    CHECK_DIGIT_TEXT_FIXED_SIZE label_seven,   7
    CHECK_DIGIT_TEXT_FIXED_SIZE label_eight,   8

    shl r10, 8*(8-4); Remove 3 characters moving to the right then to the left
    shr r10, 8*(8-4)
                ;    PRINTLN r10
    ; MACRO                     Label,         Value
    CHECK_DIGIT_TEXT_FIXED_SIZE label_four,   4
    CHECK_DIGIT_TEXT_FIXED_SIZE label_five,   5
    CHECK_DIGIT_TEXT_FIXED_SIZE label_nine,   9

    shl r10, 8*(8-3); Remove 3 characters moving to the right then to the left
    shr r10, 8*(8-3)
                ;    PRINTLN r10
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
    je .end_of_line
    cmp al, END_OF_FILE
    je .end_of_line

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
;label_one:          db      "one", 0,0,0,0,0,0,0,0
label_one:          db      "eno", 0,0,0,0,0,0,0,0
;label_two:          db      "two", 0,0,0,0,0,0,0,0
label_two:          db      "owt", 0,0,0,0,0,0,0,0
;label_three:        db      "three", 0,0,0,0,0,0,0,0
label_three:        db      "eerht", 0,0,0,0,0,0,0,0
;label_four:         db      "four", 0,0,0,0,0,0,0,0
label_four:         db      "ruof", 0,0,0,0,0,0,0,0
;label_five:         db      "five", 0,0,0,0,0,0,0,0
label_five:         db      "evif", 0,0,0,0,0,0,0,0
;label_six:          db      "six", 0,0,0,0,0,0,0,0
label_six:          db      "xis", 0,0,0,0,0,0,0,0
;label_seven:        db      "seven", 0,0,0,0,0,0,0,0
label_seven:        db      "neves", 0,0,0,0,0,0,0,0
;label_eight:        db      "eight", 0,0,0,0,0,0,0,0
label_eight:        db      "thgie", 0,0,0,0,0,0,0,0
;label_nine:         db      "nine", 0,0,0,0,0,0,0,0
label_nine:         db      "enin", 0,0,0,0,0,0,0,0
dot_message:            db  ".", 0
end_message:            db  "|", 0


space:            db  ".", 0
equals:            db  "EQUALS", 0
carriage_return: db  0xa, 0

text_as_number:  dq      0
tmp_text:  dq      0

    section   .bss
digit_text:    resb BUFFER_LETTER_SIZE

