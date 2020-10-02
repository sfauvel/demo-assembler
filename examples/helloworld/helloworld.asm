; -----------------------------------------------------------------------------
; Hello world.
;
; -----------------------------------------------------------------------------
        
        ; Define methods exported
        global  hello_world     ; Say hello
        global  to_roman
        
        section .text
to_roman:
        mov rsi, output

        ; Write to rax
        cmp rdi, 1
        jne not_I
        call _I
not_I:
        cmp rdi, 5
        je _V
        cmp rdi, 10
        je _X
        cmp rdi, 2
        je _II

to_roman_after_cmp:

        ; Add end character to string
        mov [rsi], rax
        add rsi, rbx
        mov rax, 0
        mov [rsi], rax
        
        mov rax, output
        ret

_I:
        mov rax, [I]
        mov rbx, 1
        ret
_V:
        mov rax, [V]
        mov rbx, 1
        jmp to_roman_after_cmp 
_X:
        mov rax, [X]
        mov rbx, 1
        jmp to_roman_after_cmp
_II:
        mov rax, [II]
        mov rbx, 2
        jmp to_roman_after_cmp 

hello_world:   
        mov rsi, output

        ; Write 'hello' to rax
        mov rax, [hello]
        mov [rsi], rax
        add rsi, 5

        ; Add end character to string
        mov rax, 0
        mov [rsi], rax
        
        mov rax, output
        ret                             

        section   .data   
hello:               db      'Hello'            ; String hello
world:               db      'World'            ; String world
I:                   db      'I'
V:                   db      'V'
X:                   db      'X'
II:                  db      'II'

        section   .bss        
output: resb         8*6                     ; Store score to build
