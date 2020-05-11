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
        mov rsi, score_tmp

        mov rdi, [score_a]
        call find_score_text
        call add_score

        mov rax, [score_separator]
        mov [rsi], rax
        add rsi, 1
        
        mov rdi, [score_b]
        call find_score_text
        call add_score
      
        mov rax, score_tmp
        ret                             

find_score_text:

        cmp rdi, 1
        je one_point

        cmp rdi, 2
        je two_point
        
        cmp rdi, 3
        je three_point

default_point:
        mov rdi, [score_0]
        ret 
one_point:
        mov rdi, [score_15]
        ret
two_point:
        mov rdi, [score_30]
        ret
three_point:
        mov rdi, [score_45]
        ret
                                    
add_score:
        mov rax, rdi                            ; Save parameter
        mov [rsi], rax                          ; Add string to output
      
        mov rcx, [score_0]                      ; Check if 0
        cmp rdi, rcx
        je if_one_letter_score                  
        add rsi, 1
if_one_letter_score:
        add rsi, 1
        ret

        section   .data        
score_tmp: resb         64

score_45:               db      "45", 0                   ; initial score
score_30:               db      "30", 0                   ; initial score
score_15:               db      "15", 0                   ; initial score
score_0:                db      "0",  0                   ; initial score
score_separator:        db      "-",  0                   ; initial score

score_a: dq 0
score_b: dq 0

score_init: dq 0