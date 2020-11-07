; -----------------------------------------------------------------------------
; Hello world.
;
; -----------------------------------------------------------------------------
        
        ; Define methods exported
        global  next_state_for     ; Say hello
        
        section .text
next_state_for: 
        
        mov rax, 'X'
        ret
                



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

        section   .bss        
output: resb         8*6                     ; Store score to build
