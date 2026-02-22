; -----------------------------------------------------------------------------
; 
; -----------------------------------------------------------------------------

        ; Define methods exported
        global  macro_return_42          ;
        global  macro_set_variable_to_42          ;

        %define RETURN_42    42

        %macro SET_VARIABLE 2
                mov rax, %2
                mov %1, rax
        %endmacro

        section .text
macro_return_42:
        mov rax, RETURN_42
        ret

macro_set_variable_to_42:
        SET_VARIABLE [macro_var_1], 42

        SET_VARIABLE [macro_var_2], [macro_var_1]
        mov rax, 0
        mov rax, [macro_var_2]
        ret

        section .data
macro_var_1:     dq        0
macro_var_2:     dq        0