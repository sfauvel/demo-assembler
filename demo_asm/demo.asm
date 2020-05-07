; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  return_5
        global  increment
        global  add_three_values
        global  add_with_call
        global  plus_1_and_add
        gg
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

add_with_call:
        mov rdi, 2
        mov rsi, 3
        mov rdx, 6
        call add_three_values        
        ret 

plus_1_and_add:
        add rdi, 1
        add rsi, 1
        add rdx, 1        
        call add_three_values     
        ret
