    extern printf
    
    global print_number
    global print_syscall

    section .text

; Param
;   RSI: Message to write
;   RDX: Length
print_syscall:
        push rax
        push rbx
        push rcx
        push rdi
        push rdx
        push rsi
        push r9
        push r10
        push r11
        
        ;mov rsi, %1   ; message to write using the stack address
        ;mov rdx, %2   ; message length do not include the last 0
        mov rdi, 1   ; file descriptor: 1 = STDOUT
        mov rax, 1   ; system call number (sys_write)
        syscall

        pop r11
        pop r10
        pop r9
        pop rsi
        pop rdx
        pop rdi
        pop rcx
        pop rbx
        pop rax
    ret

print:
	mov rbx,1            ; file descriptor 1 = STDOUT
    mov rdx,1            ; length of string to write
    mov rcx,rdi          ; string to write
    .next:
        mov al, [rcx]
        test al,al
        jz .finish

        mov rax,4            ; 'write' system call = 4
        int 80h   

        inc rcx
    jmp .next

    .finish:
    ret

print_text:
      push rax
      push rbx
      push rcx
      push rdx
      call print
      pop rdx
      pop rcx
      pop rbx
      pop rax
      ret


print_number:
        push rbp ; re-aligning he stack to 16-byte alignement
        push rax
        push rbx
        push rcx
        push rdx
        push rsi
        push rdi
        push r9
        push r10
        mov  rsi, rax
        mov  rdi, format_number
        xor  rax,rax
        call printf
        pop r10
        pop r9
        pop rdi
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        pop rbp
        ret

    section .data
format_number:   db '--- %llu ',10,0