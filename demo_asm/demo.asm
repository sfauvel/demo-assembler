; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  return_5
        global  increment
        global  add_three_values
        global  add_2_3_and_6_with_call
        global  plus_1_and_add
        global  say_hello
        global  say_hello_world
        
        section .text
return_5:
        mov     rax, 5                  ; result (rax) 
        ret                           

increment:
        mov     rax, rdi                ; parameter (rdi) in rax 
        add     rax, 1                  ; increment rax
        ret

add_three_values:
        mov     rax, rdi                ; move first parameter (rdi) in rax 
        add     rax, rsi                ; add second parameter (rsi)
        add     rax, rdx                ; add third parameter  (rdx)
        ret

add_2_3_and_6_with_call:
        mov rdi, 2
        mov rsi, 3
        mov rdx, 6
        call add_three_values        
        ret 

plus_1_and_add:
        add rdi, 1                      ; Add 1 to first parameter
        add rsi, 1                      ; Add 1 to second parameter
        add rdx, 1                      ; Add 1 to third parameter
        call add_three_values     
        ret

say_hello:
        mov rax, hello
        ret

say_hello_world:
        mov rax, helloworld
        ret

        section .data
hello:  db      "Hello", 0               ; End with 0 unless string continue with the next one
bye:    db      "Bye", 0

helloworld:  db      "Hello"            ; Without 0 at the end, string continue with next declearation
             db      " "
world:       db      "World", 0