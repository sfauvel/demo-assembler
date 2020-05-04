; -----------------------------------------------------------------------------
; A 64-bit function that returns the maximum value of its three 64-bit integer
; arguments.  The function has signature:
;
;   int64_t maxofthree(int64_t x, int64_t y, int64_t z)
;
; Note that the parameters have already been passed in rdi, rsi, and rdx.  We
; just have to return the value in rax.
; -----------------------------------------------------------------------------

        global  tennis_score
        section .text
tennis_score:
        mov       rsi, score              
        mov       rax, rsi                ; system call for exit
        ret                               ; return
         
        section   .data
score:  db        "0-0"                   ; initial score
        