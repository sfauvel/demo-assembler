; -----------------------------------------------------------------------------
; 
; -----------------------------------------------------------------------------
; https://docs.freebsd.org/en/books/developers-handbook/x86/#x86-system-calls
; https://blog.packagecloud.io/the-definitive-guide-to-linux-system-calls/
; https://man7.org/linux/man-pages/man2/syscalls.2.html
; https://github.com/torvalds/linux/blob/v3.13/arch/x86/syscalls/syscall_64.tbl

        ; Define methods exported
      
      GLOBAL _start
      extern print_number
      extern print_ln

EXIT    equ  60

        section .text

_start:
    mov rdi, 357912489876
    call print_number

    call print_ln

    xor rdi, rdi    ; return code 0
    mov rax, EXIT   ; exit syscall
    syscall
