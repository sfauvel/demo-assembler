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

        global read_file_to_buffer;
        global write_hard_coded_file_with_alphabet;
        global write_given_file_with_alphabet;

        section .text
read_file_to_buffer:
        open_file:
                mov rax, SYS_OPEN        ;sys_open file with fd in ebx
                mov rbx, file_to_read    ;file to be read
                mov rcx, 0               ;O_RDONLY
                int 80h

        read_from_file:
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
file_to_read    db "../work/target/demo_read_data.txt", 0
file_to_write   db "../work/target/demo_write_data.txt", 0
alphabet        db "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 0
buflen:         dw 2048 ; Size of our buffer to be used for read

        section .bss
buffer: resb 2048 ; A 2 KB byte buffer used for read
