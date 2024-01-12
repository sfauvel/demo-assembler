
global _start

extern print_text
extern print_ln

extern test_asm_fork

EXIT    equ 60
FORK    equ 0x39
WAIT4   equ 0x3d

section .text


_exit:
    xor rdi, rdi    ; return code 0
    mov rax, EXIT     ; exit syscall
    syscall
    ; Nothing done after this SYSCALL
    

thread_wait:
    ; Allocate space in the stack to store the exit code
    sub rsp, 4

    mov rdi, rax ; Move the PID to rdi for wait4 syscall
    mov rax, WAIT4 ; wait4 syscall
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
    mov rdi, start_child
    call print_text

    mov rcx, 50  ; Make a loop long enough to let another thread doing something
    mov rdi, msg_child
    .next   
        call print_text
    loop .next

    jmp _exit


test_asm_fork: 
    mov rdi, start_parent
    call print_text

    ; Fork
    mov rax, FORK ; fork syscall on x64 Linux
    syscall
    ; From here, we have two threads running.
    ; The parent one has the PID in rax when the child one has 0 in rax.

    cmp rax, 0    ; 'fork' will return 0 to the child process
    jne _child     ; split execution and go to the child part if PID is 0 otherwose (parent) continue
   
    mov rcx, 50
    mov rdi, msg_parent
    .next   
        call print_text
    loop .next

    mov rax, 0
    call thread_wait ; Wait child finish before return
   
    ret

section .data
start_parent:   db  "Parent start",10,0
msg_parent:     db  "parent",10,0
start_child:    db  "Child start",10,0
msg_child:      db  "child",10,0
