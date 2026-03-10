; -----------------------------------------------------------------------------
; Show how to handle file
; http://www.matveev.se/asm/nasm-fops.htm
; -----------------------------------------------------------------------------


SYS_READ equ 0
SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3

; O_RDONLY        0x0
; O_WRONLY        0x1
; O_RDWR          0x2
; O_APPEND        0x8
; O_CREAT       0x200
; O_TRUNC       0x400
; O_EXCL        0x800


STDIN     equ 0
STDOUT    equ 1

BLOCK_SIZE equ 1000

        global read_file_to_buffer;
        global write_given_file_with_alphabet;
        global read_file_char_by_char;
        global read_file_by_blocks;

        section .text

read_file_by_blocks:
        mov dword [current_length], 0
        mov dword [buffer_head], buffer
        
        call open_file
        mov [file_descriptor], rax  ;store new (!) fd of the same file

        .read_from_file:
                mov rax, SYS_READ
                mov rdi, [file_descriptor]
                mov rsi, short_buffer
                mov rdx, BLOCK_SIZE           ;length of data to be read
                syscall

                ; At this point rax contains number of characters read
                cmp rax, 0
                je .end_of_file
                
                mov rbx, short_buffer
                mov rcx, rax
                .next_char:
                        push rcx
                        push rax
                       
                        mov al, [rbx]
                        mov [current_char], al

                        push rbx
                        call .do_some_stuff
                        pop rbx

                        inc rbx

                        pop rax
                        pop rcx
                loop .next_char ; rcx = rcx - 1, if rcx != 0, then jump to .next

                jmp .read_from_file

        .end_of_file:
                mov rax, [buffer_head] 
                mov word [rax], 0


        mov rdi, [file_descriptor] 
        call close_file

        mov rax, buffer
        ret

        .do_some_stuff:
                ;mov rax, buffer
                ;add rax, [current_length] ; Buffer + string length => after the last character
                mov rax, [buffer_head]

                mov cl, [current_char] ; copy char to buffer (rax)
                mov [rax], cl

                inc byte  [current_length]  ; increment length
                inc dword [buffer_head]     ; increment buffer_head
                ret

read_file_to_buffer:
        call open_file
        mov [file_descriptor], rax 

        .read_from_file:
                ; read from file into buffer
                mov rdi, rax        ;store new (!) fd of the same file
                mov rax, SYS_READ       ;sys_read
                mov rsi, buffer         ;pointer to destination buffer
                mov rdx, buflen         ;length of data to be read
                syscall

                ; At this point rax contains number of characters read

                add rax, buffer  ; Buffer + string length => after the last character
                mov word [rax], 0

        mov rdi, [file_descriptor] 
        call close_file

        mov rax, buffer
        ret

read_file_char_by_char:
        mov dword [current_length], 0
        mov dword [buffer_head], buffer

        call open_file
        mov [file_descriptor], rax


        .read_next_char:
                mov rax, SYS_READ
                mov rdi, [file_descriptor]
                mov rsi, current_char
                mov rdx, 1                ;length of data to be read
                syscall

                ; At this point rax contains number of characters read
                cmp rax, 0
                je .eof

                ; do some stuff with current_char
                call .do_some_stuff

                inc byte  [current_length]  ; increment length
                inc dword [buffer_head]     ; increment buffer_head

                jmp .read_next_char

        .eof:
                ;mov rbx, [file_descriptor]

                mov rdi, [file_descriptor] 
                call close_file

        .finish:
                ; Add a 0 at the end of the buffer
                ;mov rax, buffer
                ;add rax, [current_length]
                mov rax, [buffer_head]
                mov word [rax], 0

                mov rax, buffer
                ret

        .do_some_stuff:
                ;mov rax, buffer
                ;add rax, [current_length] ; Buffer + string length => after the last character
                mov rax, [buffer_head]

                mov cl, [current_char] ; copy char to buffer (rax)
                mov [rax], cl
                ret

open_file:
        mov rax, SYS_OPEN            ;sys_open file with fd in ebx
        mov rdi, rdi          ;file to be read
        ; mov rsi,  ??         ; flag
        mov rdx, SYS_READ            ;Mode SYS_READ 0, SYS_WRITE 1
        syscall
        ret

close_file:
        mov rax, SYS_CLOSE    ;sys_close file
        syscall
        ret

write_given_file_with_alphabet:
        mov rdi, rdi
        mov rsi, 0102o     ;O_CREAT, man open flag
        mov rdx, 0666o     ;umode_t mode
        mov rax, SYS_OPEN
        syscall
        mov [file_descriptor], rax 

        mov rdi, rax        ;file descriptor
        mov rsi, alphabet   ;message to write
        mov rdx, 26         ;message length do not include the last 0
        mov rax, SYS_WRITE  ;system call number (sys_write)
        syscall             ;call kernel


        mov rdi, [file_descriptor] 
        call close_file
        ret

        section   .data
        
alphabet:        db "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0
current_length:  dq 0
buffer_head:     dq 0
file_descriptor: dq 0
buflen:          dw 2048 ; Size of our buffer to be used for read

        section .bss
current_char:    resb 1
buffer:          resb 2048 ; A 2 KB byte buffer used for read
short_buffer:    resb BLOCK_SIZE ; 
