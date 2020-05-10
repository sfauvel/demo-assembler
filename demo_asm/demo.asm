; -----------------------------------------------------------------------------
; A 64-bit functions
; -----------------------------------------------------------------------------

        global  return_5
        global  increment
        global  decrement
        global  add_three_values
        global  add_2_3_and_6_with_call
        global  plus_1_and_add
        
        section .text
return_5:
        mov     rax, 5                  ; result (rax) 
        ret                           

increment:
        mov     rax, rdi                ; parameter (rdi) in rax 
        inc     rax                     ; increment rax
        ret

decrement:
        mov     rax, rdi                ; parameter (rdi) in rax 
        dec     rax                     ; decrement rax
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
