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



        section   .data
file_to_read db "../work/target/demo_data.txt", 0
buflen: dw 2048 ; Size of our buffer to be used for read

        section .bss
buffer: resb 2048 ; A 2 KB byte buffer used for read