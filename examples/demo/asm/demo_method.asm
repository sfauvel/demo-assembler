; -----------------------------------------------------------------------------
; Can define several methods in the same file.
;
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  method_return_2     ;
        global  method_return_3     ;
        global  method_local_label  ;

        section .text
method_return_2:
        mov rax, 2
        ret

method_return_3:
        mov rax, 3
        ret


method_other_local_label:
        mov rax, 15
        jmp .local_label
        mov rax, 19
        .local_label:
        ret

method_local_label:
        ; Local label start woth '.'
        ; We can reuse the same local label after the next label
        mov rax, 5
        jmp .local_end
        mov rax, 9
        .local_end:
        ret
