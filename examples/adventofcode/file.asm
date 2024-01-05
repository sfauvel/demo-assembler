; -----------------------------------------------------------------------------
; Handle files
; -----------------------------------------------------------------------------

global compute_file

SYS_READ  equ 3
SYS_WRITE equ 4
SYS_OPEN  equ 5
SYS_CLOSE equ 6
BLOCK_SIZE equ 1000 ; We can slightly improve perf with a greater value

    section .data
current_length:   dq 0
file_descriptor:  dq 0
function_pointer: dq 0

    section .bss
current_char:    resb 1
short_buffer:    resb BLOCK_SIZE

    section .text

; Read a file and call a method for each character.
; Parameters
;    RDX: filename
;    RSI: pointer to function that is called on each character
compute_file:
    mov [function_pointer], rsi
    mov dword [current_length], 0
        
    call open_file
    mov [file_descriptor], rax  ;store new (!) fd of the same file

    .read_from_file:
        mov rax, SYS_READ       
        mov rbx, [file_descriptor]
        mov rcx, short_buffer         ;pointer to destination buffer
        mov rdx, BLOCK_SIZE           ;length of data to be read
        int 80h

        ; At this point rax contains number of characters read
        cmp rax, 0
        je .end_of_file
        
        mov rbx, short_buffer
        mov rcx, rax
        .next_char:
            push rcx
            push rbx
            
            mov al, [rbx]
            mov [current_char], al

            ; Compute one character
            mov rdx, current_char
            call [function_pointer]

            pop rbx
            inc rbx

            pop rcx

            dec rcx
            cmp rcx, 0
            jne .next_char ; Seems to be more efficient than a loop instruction
            ;loop .next_char ; rcx = rcx - 1, if rcx != 0, then jump to .next

        jmp .read_from_file

    .end_of_file:
        call close_file

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
