; -----------------------------------------------------------------------------
; Show how to retrieve parameters.
; Parameters can be found in rdi, rsi, and rdx
; Return value is in rax
; -----------------------------------------------------------------------------
SYS_EXIT  equ 1
STDIN     equ 0
STDOUT    equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
SYS_OPEN  equ 5
SYS_CLOSE equ 6

        extern printf

        ; Define methods exported
        global  read_file     ;
        global  read_file_to_buffer     ;

        section .text
; read_file:
;         call number_to_console
;         call string_to_console
;         mov rax, 88
;         mov [buffer+0], rax
;         mov [buffer+1], rax
;         mov [buffer+2], rax
;         mov [buffer+3], rax
;         mov [buffer+4], rax
;         mov [buffer+5], rax
;         mov rax, 0
;         mov [buffer+6], rax
;         call string_to_console
;         call write_file;


;         mov rax, 87
;         mov [buffer+0], rax
;         mov [buffer+1], rax
;         mov [buffer+2], rax
;         mov [buffer+3], rax
;         mov [buffer+4], rax
;         mov [buffer+5], rax
;         mov rax, 0
;         mov [buffer+6], rax
;         call string_to_console
;         call read_file_xx
;         call string_to_console


;        ; mov rax, 80
;         ;mov [buffer+0], rax
;         xor rax,rax
;         movzx ax, [buffer+0]  ;move byte to doubleword, zero extension
; ;
;      ;   xor rsi,rsi
;      ;   
;      ;   mov rbx, file_to_read ; Move our file descriptor into ebx
;      ;   mov rax, 0x03 ; syscall for read = 3
;      ;   mov rcx, buffer ; Our 2kb byte buffer
;      ;   mov rdx, buflen ; The size of our buffer
;      ;   int 0x80
;      ;   test rax, rax ; Check for errors / EOF
;      ; ;  ;jz file_out ; If EOF, then write our buffer out.
;      ; ;  ;js exit ; If read failed, we exit.
; ;
;      ;   mov rdi, 1      ; stdout fd
;      ;   mov rsi, buffer
;      ;   mov rdx, 5      ; 8 chars + newline
;      ;   mov rax, 1      ; write syscall
;      ;   syscall

;         ;mov  rsi, buffer
;         ;mov  rdi, format_string
;         ;  xor rax,rax
;         ;call printf
;         ret

; read_file_xx:
; ;http://www.matveev.se/asm/nasm-fops.htm
;         mov rax, 5		;sys_open file with fd in ebx
; 	mov rbx, file_name		;file to be re-opened
; 	mov rcx, 0		;O_RDONLY
; 	int 80h

;         mov rbx, rax		;store new (!) fd of the same file

; ; read from file into bss data buffer

; 	mov rax, 3		;sys_read
; 	mov rcx, buffer		;pointer to destination buffer
; 	mov rdx, 3		;length of data to be read
; 	int 80h
		
;         mov rax, 6	;sys_close file
; 	int 80h
;         ret

read_file_to_buffer:
;http://www.matveev.se/asm/nasm-fops.htm

        open_file:
                push rdi ;length of data to be read

                mov rax, SYS_OPEN		;sys_open file with fd in ebx
                mov rbx, file_to_read	;file to be read
                mov rcx, 0		;O_RDONLY
                int 80h

        read_from_file:
                mov rbx, rax		;store new (!) fd of the same file
        
                ; read from file into buffer

                mov rax, SYS_READ		;sys_read
                mov rcx, buffer		;pointer to destination buffer
                pop rdx                 ;length of data to be read
                int 80h

                ; At this point rax contains number of characters read

                add rax, buffer  ; Buffer + string length => after the last character
                mov word [rax], 0

        close_file:
                mov rax, SYS_CLOSE	;sys_close file
                int 80h

        mov rax, buffer
        ret


; ;https://www.tutorialspoint.com/assembly_programming/assembly_system_calls.htm
;     mov rdi, file_name		; Setting file name to be opened
;     mov rax, 3		; sys_read system call
;     mov rcx, buffer		; for read only access
;     syscall

;     mov [fd_in], rax		; Reading file descriptor of opened file in fd_in
;     mov rdx, 6	
;     mov rsi, buffer		; Reading in info
;     mov rdi, [fd_in]
;     mov rcx, buffer	
;     mov rax, 3		; sys_read system call
;     syscall

;     mov rbx, [fd_in]		; file descriptor fd_in
;     mov rax, 3	
;     syscall                                
;     ret


;  ;   mov rdi, file_name
;  ;   mov rcx, 0
;  ;   mov rdx, 0666o     ;umode_t
;  ;   mov rax, 3
;  ;   syscall
; ;
;  ;   mov [fd_in], rax
;  ;   mov eax, 3		; sys_read system call
;  ;   mov ebx, [fd_in]		; file descriptor fd_in
;  ;   mov ecx, buffer		; Reading in info
;  ;   mov edx, 10	
;  ;   int 0x80		; Perform the system call
;  ;   mov eax, 6		; sys_close system call

                                    



; write_file:
;     mov rdi, file_name
;     mov rsi, 0102o     ;O_CREAT, man open
;     mov rdx, 0666o     ;umode_t
;     mov rax, 2
;     syscall

;     mov [fd], rax
;     mov rdx, 6    ;message length
;     mov rsi, buffer       ;message to write
;     mov rdi, [fd]      ;file descriptor
;     mov rax, 1         ;system call number (sys_write)
;     syscall            ;call kernel

;     mov rdi, [fd]
;     mov rax, 3         ;sys_close
;     syscall
;     ret

; number_to_console:
;         push rdx
;         push rax
;         mov  rsi, 58
;         mov  rdi, format_number
;         xor rax,rax
;         call printf
;         pop rax
;         pop rdx
;         ret

; string_to_console:
;         push rdx
;         push rax
;         mov  rsi, buffer
;         mov  rdi, format_string
;         xor rax,rax
;         call printf
;         pop rax
;         pop rdx
;         ret


;         section   .data


file_name db "../work/data_xx.txt", 0
;file_to_read db "../work/tmp.sh", 0

file_to_read db "../examples/file/data.txt", 0
hello db "Hello world !", 0	
buflen: dw 2048 ; Size of our buffer to be used for read
format_number:        db '%d',                   10,0;
format_string:        db '%s',                   10,0;
fd dq 0
fd_in dq 0

        section .bss
buffer: resb 2048 ; A 2 KB byte buffer used for read
