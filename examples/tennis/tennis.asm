; -----------------------------------------------------------------------------
; Tennis game.
;
; Return score of a tennis game according to points win by each players.
;
; -----------------------------------------------------------------------------
        
        global  start_game      ; Start a new game. Must be call before starting to reinit variables.
        global  tennis_score    ; Return score as a string like: 30-15.
        global  a_score         ; Player A win a point.
        global  b_score         ; Player B win a point.

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

        ; Add player A score
        mov rdi, [score_a]
        call find_score_text
        call add_score

        ; Add separator
        mov rax, [score_separator]
        mov [rsi], rax
        add rsi, 1
        
        ; Add player B score
        mov rdi, [score_b]
        call find_score_text
        call add_score
      
        ; Add end character to string
        mov rax, 0
        mov [rsi], rax

        ; return score
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
score_0:                db      '0'             ; String to display when 0
score_15:               db      '15'            ; String to display when 15
score_30:               db      '30'            ; String to display when 30 
score_45:               db      '45'            ; String to display when 45
score_separator:        db      '-'             ; Separator between player score

score_a:                dq      0               ; Player B points
score_b:                dq      0               ; Player A points

        section   .bss        
score_tmp: resb         8*6                     ; Store score to build
