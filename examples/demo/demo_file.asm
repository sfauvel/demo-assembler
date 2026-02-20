; -----------------------------------------------------------------------------
; Show how to handle file
; http://www.matveev.se/asm/nasm-fops.htm
; -----------------------------------------------------------------------------


SYS_EXIT  equ 1
STDIN     equ 0
STDOUT    equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
SYS_OPEN  equ 5
SYS_CLOSE equ 6

BLOCK_SIZE equ 1000

        global read_file_to_buffer;
        global write_hard_coded_file_with_alphabet;
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
                mov rax, SYS_READ       ;sys_read
                mov rbx, [file_descriptor]
                mov rcx, short_buffer         ;pointer to destination buffer
                mov rdx, BLOCK_SIZE         ;length of data to be read
                int 80h

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

        .read_from_file:
                mov rbx, rax        ;store new (!) fd of the same file
    

                ; read from file into buffer

                mov rax, SYS_READ       ;sys_read
                mov rcx, buffer         ;pointer to destination buffer
                mov rdx, buflen         ;length of data to be read
                int 80h

                ; At this point rax contains number of characters read

                add rax, buffer  ; Buffer + string length => after the last character
                mov word [rax], 0

        call close_file

        mov rax, buffer
        ret

read_file_char_by_char:
        mov dword [current_length], 0
        mov dword [buffer_head], buffer

        call open_file
        mov [file_descriptor], rax


        .read_next_char:
                mov rax, SYS_READ       ;sys_read
                mov rbx, [file_descriptor]
                mov rcx, current_char   ;pointer to destination buffer
                mov rdx, 1              ;read one character
                int 80h

                ; At this point rax contains number of characters read
                cmp rax, 0
                je .eof

                ; do some stuff with current_char
                call .do_some_stuff

                inc byte  [current_length]  ; increment length
                inc dword [buffer_head]     ; increment buffer_head

                jmp .read_next_char

        .eof:
                mov rbx, [file_descriptor]
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
        mov rax, SYS_OPEN        ;sys_open file with fd in ebx
        mov rbx, file_to_read    ;file to be read
        mov rcx, 0               ;O_RDONLY
        int 80h
        ret

close_file:
        mov rax, SYS_CLOSE    ;sys_close file
        int 80h
        ret

write_hard_coded_file_with_alphabet:
        mov rdi, file_to_write
        call write_given_file_with_alphabet
        ret

write_given_file_with_alphabet:
        mov rsi, 0102o     ;O_CREAT, man open
        mov rdx, 0666o     ;umode_t
        mov rax, 2
        syscall

        mov rdx, 26         ;message length do not include the last 0
        mov rsi, alphabet   ;message to write
        mov rdi, rax        ;file descriptor
        mov rax, 1          ;system call number (sys_write)
        syscall             ;call kernel

        call close_file
        ret

        section   .data
file_to_read:    db "./work/target/demo_read_data.txt", 0
file_to_write:   db "./work/target/demo_write_data.txt", 0
alphabet:        db "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0
current_length:  dq 0
buffer_head:     dq 0
file_descriptor: dq 0
buflen:          dw 2048 ; Size of our buffer to be used for read

        section .bss
current_char:    resb 1
buffer:          resb 2048 ; A 2 KB byte buffer used for read
short_buffer:    resb BLOCK_SIZE ; 
