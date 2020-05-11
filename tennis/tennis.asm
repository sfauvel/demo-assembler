; -----------------------------------------------------------------------------
; A 64-bit function that returns the maximum value of its three 64-bit integer
; arguments.  The function has signature:
;
;   int64_t maxofthree(int64_t x, int64_t y, int64_t z)
;
; Note that the parameters have already been passed in rdi, rsi, and rdx.  We
; just have to return the value in rax.
; -----------------------------------------------------------------------------
        extern	printf	


        global  start_game
        global  a_score
        global  b_score
        global  tennis_score

        section .text
start_game:
        mov rax, 0
        mov [score_a], rax
        mov [score_b], rax
        ret

a_score:
        mov rax, [score_a]
        inc rax
        mov [score_a], rax
        ret

b_score:
        mov rax, [score_b]
        inc rax
        mov [score_b], rax
        ret

tennis_score:   
        mov rbx, 0
        mov rcx, [score_a]
        cmp rbx, rcx

        jc  return_score_15_0
        jmp return_score

return_score_15_0:
        mov rax, [score_15]
        mov [score_tmp], rax

        mov rax, [score_separator]
        mov [score_tmp+2], rax
        
        mov rax, [score_0] 
        mov [score_tmp+3], rax
        
        mov rax, score_tmp
        ret                    

 return_score:     
        mov rax, [score_0]
        mov [score_tmp], rax

        mov rax, [score_separator]
        mov [score_tmp+1], rax
        
        mov rax, [score_0] 
        mov [score_tmp+2], rax
        
        mov rax, score_tmp
        ret                                  

        section   .data        
score_tmp: resb         64

score_15:               db      "15", 0                   ; initial score
score_0:                db      "0",  0                   ; initial score
score_separator:        db      "-",  0                   ; initial score

score_a: dq 0
score_b: dq 0
