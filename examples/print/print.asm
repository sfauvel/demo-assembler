; -----------------------------------------------------------------------------
; 
; -----------------------------------------------------------------------------

        ; Define methods exported
      GLOBAL print_text
      GLOBAL print_number

        section .text
print:

	mov rbx,1            ; file descriptor 1 = STDOUT
      mov rdx,1            ; length of string to write

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
      mov  rcx,rdi
      call print
      pop rdx
      pop rcx
      pop rbx
      pop rax
      ret

print_number:
      push rax
      push rbx
      push rcx
      push rdx
      push r8

      mov rax, rdi

      mov r8, 0
      mov rcx, 10
      
      .next_extract:
      mov rdx, 0
      div rcx
      push rdx
      inc r8
      test al,al
      jnz .next_extract

      .finish_extract:
    
      .next_display:
      pop rdx
      add rdx, 48
      mov [var_tmp], rdx
      mov rcx, var_tmp
      call print
      dec r8
      mov rax, r8
      test al,al
      jnz .next_display
 
      pop r8
      pop rdx
      pop rcx
      pop rbx
      pop rax

      ret

        section   .bss        
var_tmp: resb         4                    ; Store score to build