; -----------------------------------------------------------------------------
; 
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  string_get_param          ;
        global  string_substring_from     ;

        section .text
string_get_param:
        mov rax, rdi
        ret


string_substring_from:
        mov rax, rdi   ; first param is a pointer to the array char 
        add rax, rsi   ; increment pointer with second parameter value
        ret