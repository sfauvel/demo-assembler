; -----------------------------------------------------------------------------
; Can define several methods in the same file.
;
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  method_return_2     ;
        global  method_return_3     ;

        section .text
method_return_2:
        mov rax, 2
        ret

method_return_3:
        mov rax, 3
        ret