; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  say_hello
        global  say_hello_world
        global  say_hello_world_and_new_line
        
        section .text
say_hello:
        mov rax, hello
        ret

say_hello_world:
        mov rax, helloworld
        ret

say_hello_world_and_new_line:
        mov rax, helloworld_and_return
        ret

        section .data
hello:  db      "Hello", 0               ; End with 0 unless string continue with the next one
bye:    db      "Bye", 0

helloworld:  db      "Hello"            ; Without 0 at the end, string continue with next declearation
             db      " "
world:       db      "World", 0

helloworld_and_return:       db      "Hello World", 10, 13, 0