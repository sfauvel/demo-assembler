; -----------------------------------------------------------------------------
; Show how to store variable and how to retrieve value
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  variable_return     ;

        section .text
variable_return:
        mov [my_var], rdi

        mov rax, 5
        mov [other_var], rax

        mov rax, [my_var]
        ret

        section .data
my_var:     dq        0
other_var:  dq        0