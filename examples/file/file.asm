; -----------------------------------------------------------------------------
; Show how to use files
; -----------------------------------------------------------------------------


SYS_READ equ 0
SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_CLOSE equ 3

; FLAGS
O_ACCMODE      equ 0x3
O_APPEND       equ 0x400
O_ASYNC        equ 0x2000
O_CLOEXEC      equ 0x80000
O_CREAT        equ 0x40
O_DIRECT       equ 0x4000
O_DIRECTORY    equ 0x10000
O_DSYNC        equ 0x1000
O_EXCL         equ 0x80
O_FSYNC        equ 0x101000
O_LARGEFILE    equ 0x0
O_NDELAY       equ 0x800
O_NOATIME      equ 0x40000
O_NOCTTY       equ 0x100
O_NOFOLLOW     equ 0x20000
O_NONBLOCK     equ 0x800
O_RDONLY       equ 0x0
O_RDWR         equ 0x2
O_RSYNC        equ 0x101000
O_SYNC         equ 0x101000
O_TRUNC        equ 0x200
O_WRONLY       equ 0x1


STDIN     equ 0
STDOUT    equ 1

        ; Define methods exported
        global  read_file_to_buffer     ;
        global  write_file              ;

        section .text

; RDI: filename
open_file_to_read:
        mov rax, SYS_OPEN            ; sys_open file with fd in ebx
        xor rsi, rsi                 ; Flags
        mov rdx, SYS_READ            ; Mode SYS_READ, SYS_WRITE
        syscall
        mov [fd], rax 
        ret

; RDI: filename
open_file_to_write:
        mov rax, SYS_OPEN
        xor rsi, rsi                 ; Flags
        add rsi, O_WRONLY
        add rsi, O_CREAT
        mov rdx, 0666o     ;umode_t
        syscall
        mov [fd], rax 
        ret

close_file:
        mov rdi, [fd] 
        mov rax, SYS_CLOSE 
        syscall
        ret

read_file_to_buffer:
        push rdi            ; File to write  

        pop rdi             ; File to write   
        call open_file_to_read

        .read_from_file:
                ; read from file into buffer
                mov rdi, [fd]           ;store new (!) fd of the same file
                mov rax, SYS_READ       ;sys_read
                mov rsi, buffer         ;pointer to destination buffer
                mov rdx, buflen         ;length of data to be read
                syscall

                ; At this point rax contains number of characters read
                add rax, buffer  ; Buffer + string length => after the last character
                mov word [rax], 0

        call close_file

        mov rax, buffer
        ret


; RDI: String pointer
; Return in RAX: Length of the string
string_length:
        mov rax, rdi
        .not_the_end:
                inc rax
                cmp byte [rax], 0 ; Check if it's the end (O)
        jnz .not_the_end
        sub rax, rsi ; Size is the difference between address of the last character (0) and address of the buffer
        ret

; RDI: File to write  
; RSI: String to write
write_file:
        push rdi
        push rsi
        call open_file_to_write 
        pop rsi
        pop rdi

        push rdi
        push rsi
        mov rdi, rsi
        call string_length
        pop rsi
        pop rdi

        .write_to_file:
                ; RSI: string to write
                mov rdi, [fd]       ; file descriptor
                mov rdx, rax        ; message length
                mov rax, SYS_WRITE  ; system call number (sys_write)
                syscall             ; call kernel
   
        call close_file
        ret


        section   .data
buflen: dw 2048 ; Size of our buffer to be used for read
fd: dq 0

        section .bss
buffer: resb 2048 ; A 2 KB byte buffer used for read
