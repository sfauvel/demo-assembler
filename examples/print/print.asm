; -----------------------------------------------------------------------------
; 
; -----------------------------------------------------------------------------
; https://docs.freebsd.org/en/books/developers-handbook/x86/#x86-system-calls
; https://blog.packagecloud.io/the-definitive-guide-to-linux-system-calls/
; https://man7.org/linux/man-pages/man2/syscalls.2.html
; https://github.com/torvalds/linux/blob/v3.13/arch/x86/syscalls/syscall_64.tbl

; Define methods exported
GLOBAL print_text
GLOBAL print_number
GLOBAL print_ln


WRITE            equ 0x01
STDOUT           equ 0x01
CARRIAGE_RETURN  equ 0x0A

; Set character at the address and increment it.
; Params:
;    1: register that contain address of the character to set
;    2: ascii code of character to insert (48 for '0')  
; Example:
;     mov rax, message
;     ADD_CHAR rax, 'a'
%macro ADD_CHAR 2
    mov byte [%1], %2
    inc %1
%endmacro

; Set a character into a string
; Params:
;   1: variable that contain string
;   2: index of the character to set
;   3: ascii code of character to insert (48 for '0')
; Example:
;     SET_CHAR message, 8, cl
%macro SET_CHAR 3
    push rax
    mov rax, %1
    add rax, %2
    mov byte [rax], %3
    pop rax
%endmacro

; Transform number to its digit 
; Params:
;   1: variable that contain string
;   2: index of the character to set
;   3: value to insert (a number 0 for '0')
; Example:
;     SET_NUMBER_CHAR message, 8, cl
%macro SET_NUMBER_CHAR 3
    push rax
    mov rax, %1
    add rax, %2
    mov byte [rax], %3
    add byte [rax], '0'
    pop rax
%endmacro

; Example:
;     PRINT_ONE_CHAR 'A'
%macro PRINT_ONE_CHAR 1
    push rdi
    push %1
    mov rdi, rsp
    call print_one_char
    add rsp, 8
    pop rdi
%endmacro

        section .text

;write:
;    mov rdx, rsi  ; move the length to rdx
;    mov rsi, rdi  ; move the pointer (rdi) to rsi
;    mov rax, WRITE ; write syscall on x64 Linux
;    mov rdi, 0x01 ; STDOUT file descriptor
;    syscall
;    ret

; See https://man7.org/linux/man-pages/man2/write.2.html
; ssize_t write(int fd, const void buf[.count], size_t count);
;    fd    (RDI): STDOUT file descriptor
;    buf   (RSI): Pointer to the buffer to write
;    count (RDX): Size to write
; return (RAX) number of characters
write:
    mov rax, WRITE ; write syscall on x64 Linux
    syscall
    ret

; write to the stdout
;    buf   (RSI): Pointer to the buffer to write
;    count (RDX): Size to write
; return (RAX) number of characters
write_stdout:
    mov rdi, STDOUT   ; STDOUT file descriptor
    mov rax, WRITE    ; write syscall on x64 Linux
    syscall
    ret

; write to the stdout
;    buf   (RDI): Pointer to the buffer to write
; return (RAX) number of characters
print_one_char:
    push rax
    push rbx
    push rcx
    push rdi
    push rdx
    push rsi
    mov  rsi,rdi

    mov rdx, 1
    mov rdi, STDOUT   ; STDOUT file descriptor
    mov rax, WRITE    ; write syscall on x64 Linux
    syscall
    
    pop rsi
    pop rdx
    pop rdi
    pop rcx
    pop rbx
    pop rax
    ret

; Print char until 0
; Param: 
;   buf   (RDI): pointer to the buffer to write
write_until_0:
    mov rsi, rdi

    ; Compute size
    mov rdx, rsi
    dec rdx
    .not_the_end:
        inc rdx
        cmp byte [rdx], 0 ; Check if it's the end (O)
    jnz .not_the_end
    sub rdx, rsi   ; Size is the difference between address of the last character (0) and address of the buffer

    mov rdi, STDOUT
    mov rax, WRITE ; write syscall on x64 Linux
    syscall
    
    ret

; Write a crriage return
print_ln:
    push rax
    push rbx
    push rcx
    push rdi
    push rdx
    push rsi
    mov rdi, CARRIAGE_RETURN
    mov rdx, 1
    call _print_reg

    pop rsi
    pop rdx
    pop rdi
    pop rcx
    pop rbx
    pop rax
    ret

; Print all characters stored in RDI
; Param
;     RDI : value to push and print
_print_full_reg:
    mov rdx, 8
    call _print_reg
    ret

; Print characters stored in RDI
; Param
;     RDI : value to push and print
;     RDX : number of character to print (between 1 to 8)
_print_reg:
    push rdi
    mov rdi, STDOUT
    mov rsi, rsp
    call write
    add rsp, 8
    ret

; Display the number in RDI
; Param:
;    RDI: Number to display
_print_number:
    mov rax, rdi ; Value to display

    mov r8, 0   ; Nb digit numbers
    mov r9, 10  ; Divisor
    
    mov r10, 0
    mov r11, 0  ; Nb of 8 digits
    .next_extract:
        mov rdx, 0
        div r9   ; RAX/R9 => RAX=quotient, RDX=remainder

        add rdx, '0'
        shl r10, 8
        add r10b, dl 
        inc r8
        cmp r8, 8
        jl .address_not_full
            inc r11
            push r10
            mov r10, 0
            mov r8, 0
        .address_not_full:

        test rax,rax
    jnz .next_extract

    inc r11
    push r10

    push r8 ; number of characters in the last value
    push r11 ; number of value in stack

    ; Stack contains text to display
    ; - number of value in stack
    ; - number of characters in the last value
    ; - text to display
    
    pop rcx ; number of value in stack
    pop rdx ; number of characters in the last value

    .next_part:
        pop rdi
        push rcx
        call _print_reg
        pop rcx
        mov rdx, 8 ; After the first text, the others have 8 characters

    loop .next_part
    
    ret

; Param:
;    RDI: Pointer to the buffer to write
print_text:
    push rax
    push rbx
    push rcx
    push rdi
    push rdx
    push rsi
    mov  rsi,rdi

    call write_until_0
    
    pop rsi
    pop rdx
    pop rdi
    pop rcx
    pop rbx
    pop rax
    ret

; Display the number in RDI
; Param:
;    RDI: Number to display
print_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push r8
    push r9
    push r10
    push r11

    call _print_number

    pop r11
    pop r10
    pop r9
    pop r8
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret
