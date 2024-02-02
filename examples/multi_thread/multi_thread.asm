; From 
; - https://dev.to/ahmedwadod/x64-assembly-multithreading-from-scratch-part-1-hello-world-59p3
; - https://dev.to/ahmedwadod/x64-assembly-multithreading-from-scratch-part-2-threads-11g1
; - https://nullprogram.com/blog/2015/05/15/
; - https://www.codequoi.com/en/creating-and-killing-child-processes-in-c/

%include '../print/print.asm'

        global xxx_start

EXIT equ 60
FORK equ 0x39

section .text

_exit_child:
    mov rdi, bye_child ; pointer to the message
    call print_text
    
    xor rdi, rdi    ; return code 0
    mov rax, EXIT     ; exit syscall
    syscall

_exit_parent:
    mov rdi, bye_parent ; pointer to the message
    call print_text

    xor rdi, rdi    ; return code 0
    mov rax, EXIT     ; exit syscall
    syscall

_exit:
    xor rdi, rdi    ; return code 0
    mov rax, EXIT     ; exit syscall
    syscall
    ; Nothing done after this SYSCALL
    
_print_start:
    push rax
    mov rax, message
    ADD_CHAR rax, 'S'
    ADD_CHAR rax, 'T'
    ADD_CHAR rax, 'A'
    ADD_CHAR rax, 'R'
    ADD_CHAR rax, 'T'
    ADD_CHAR rax, CARRIAGE_RETURN
    ADD_CHAR rax, 0
    mov rdi, message

    call print_text

    pop rax
    ret

show_pid:
    push rax
   
    mov rdi, format_pid
    call print_text

    mov rdi, rax
    call print_number
    ;call print_ln

    pop rax
    ret

xxx_start: 
    call _print_start
    mov rdi, msg ; pointer to the message
    call print_text

    ; Fork
    mov rax, FORK ; fork syscall on x64 Linux
    syscall
    
    ; From here, we have two threads running.
    ; The parent one has the PID in rax when the child one has 0 in rax.
    push rax
    call show_pid
    pop rax
push rax
    mov rdx, 'A'
    cmp rax, 0    ; 'fork' will return 0 to the child process
pop rax
    je _child     ; split execution and go to the child part if PID is 0 otherwose (parent) continue


;call thread_wait

    ; Fork
    mov rax, FORK ; fork syscall on x64 Linux
    syscall

    ; From here, we have two threads running.
    ; The parent one has the PID in rax when the child one has 0 in rax.
    push rax    
    call show_pid

    ; Display message address. It's the same for parent and child process
    mov rdi, message
    call print_number
    call print_ln

    pop rax
push rax
    mov rdx, 'B'
    cmp rax, 0    ; 'fork' will return 0 to the child process
pop rax
    je _child

call thread_wait

    mov rcx, 2
    .print_parent:
        push rcx
        mov rdi, hello_parent ; pointer to the message
        call print_text
        pop rcx
    loop .print_parent
    
    ;wait(NULL)
	;mov rax,0x7
	mov rax,0x72 ; wait
	syscall
    ret
    ;jmp _exit_parent

thread_wait:
    ; Allocate space in the stack to store the exit code
    sub rsp, 4

    mov rdi, rax ; Move the PID to rdi for wait4 syscall
    mov rax, 0x3d ; wait4 syscall
    mov rsi, rsp ; Pointer to the exit code space
    mov rdx, 0x00 ; Flags
    mov r10, 0x00 ; NULL pointer
    syscall

    ; Store the exit code in EAX (4 byte value of rax)
    mov eax, [rsp]
    add rsp, 4

    ret

; The begining of the message with the process name is written only once.
; At the execution, we see that the message is the one set by the process
; even another process write durintg the loop.
; Each messages are independant
_child:
    mov r9b, dl

    SET_CHAR child, 6, r9b

    mov rcx, 60
    .print_child:
        push rcx
        SET_NUMBER_CHAR child, 8, cl
        mov rdi, child
        call print_text

        pop rcx
    loop .print_child

    jmp _exit_child



        section   .bss        
var_tmp: resb         4                    ; Store score to build

section .data
msg:             db "hi there !", 10,0
hello_parent:    db "Hello from parent!",10,0
bye_parent:      db "Goodbye parent!",10,0
hello_A:         db "Hello from child A!",10,0
hello_B:         db "Hello from child B!",10,0
bye_child:       db "Goodbye child!",10,0
format_pid:      db "PID: ",0
child:           db "Child_?(?)",10,0

section .bss
message:      resb 2048