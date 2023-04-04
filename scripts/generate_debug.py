# from ctypes import *
# so_file = "../../target/demo_xxx.so"
# my_functions = CDLL(so_file)

# Add instructions between each lines to trace register values
import os
import re



def copy_asm():
    lines =[]
    procedure_part = False
    print(f"{PROJECT_PATH}/{DEMO}.asm")
    with open(f"{PROJECT_PATH}/{DEMO}.asm", "r") as input:
        for line in input:
            # print(line.rstrip())
            lines.append(line)

    os.makedirs(DEBUG_PATH, exist_ok=True )
    with open(f"{DEBUG_PATH}/{DEMO}.debug.asm", "w") as output:
        counter = 0
        instructions = []
        for line in lines:
            if (re.search('section +\.text', line)):
                output.write(macro_code())
                procedure_part = True
            
            if (re.search('section +\.data', line)):
                procedure_part = False
            if (re.search('section +\.bss', line)):
                procedure_part = False

            output.write(line)
            if procedure_part:
                if (line.strip() != ""):
                    if line.startswith("algo_to_debug:"):
                        output.write(f"        call begin_table\n")
                   
               
                    instructions.append(line.strip())
                    output.write(f"        DISPLAY_CMD instruction_{DEMO}_{counter}\n")
                    counter += 1
            
        output.write(debug_code())
        
        counter = 0

        output.write(f"        section   .data\n")
        output.write(f"space      db       ' ', 0;\n")
        output.write(f"table      db       '|====', 0;\n")
        output.write(f"cell       db       '|', 0;\n")
        output.write(f"new_line   db       10, 0;\n")
        output.write(f"next_line  db       ',',0;\n")
            
        for line in instructions:
            formatted_line = line.split(";")[0].strip()#.replace(':','\\:')
            output.write(f"instruction_{DEMO}_{counter}  db       '{formatted_line}',0;\n")
            counter += 1
            
            
            
            # rsp :140729689718504
            # rbp :140729689718544 => +40=5*8
def macro_code():
    return """
        extern print_text
        extern print_number
        extern display_stack
        extern display_flags

        %macro DISPLAY_CMD 1
                
                push rax
                push rcx
                push rdi   
                push rsi
                push rdx
                push r8
                push r9
                push r10
                push r11
                pushfq
                
                
                mov rdi, cell
                call print_text
                
                mov rdi, %1
                call print_text
                
                PRINT_REGISTER 8*8
                PRINT_REGISTER 8*7
                PRINT_REGISTER 8*6
                PRINT_REGISTER 8*5
                PRINT_REGISTER 8*4
                PRINT_REGISTER 8*3
                PRINT_REGISTER 8*2
                PRINT_REGISTER 8*1
                PRINT_REGISTER 8*0
                
                
                mov rdi, cell
                call print_text
                mov rax, rsp
                add rax, 8*9
                mov rdi, rax
                call display_stack
                
                
                mov rdi, cell
                call print_text
                mov rsi, [rsp]
                call display_flags
                
                mov rdi, new_line
                call print_text
                
                popfq
                pop r11
                pop r10
                pop r9
                pop r8
                pop rdx   
                pop rsi
                pop rdi
                pop rcx
                pop rax

        %endmacro
        
        
        %macro PRINT_REGISTER 1
                mov rdi, cell
                call print_text
                
                mov rdi, [rsp+%1]
                call print_number  
                
                mov rdi, space
                call print_text
        %endmacro
        

        
    """
    
def debug_code():
    return """
"""

import sys
if __name__ == "__main__":
    if (len(sys.argv)<=3):
        raise "Too few arguments"
    PROJECT_PATH=sys.argv[1]
    DEMO=sys.argv[2]
    DEBUG_PATH=sys.argv[3]
   
    copy_asm()