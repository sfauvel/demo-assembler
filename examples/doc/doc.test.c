#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>


#include <test.h>

#include <demo_if.h>

#define SIZE 10000

#define COLUMN_INSTRUCTION    1
#define COLUMN_RAX            2
#define COLUMN_RBX            3
#define COLUMN_RCX            4
#define COLUMN_RDI            5
#define COLUMN_FLAGS         13

#define FLAG_CF 0 // Carry flag 	Status 	CY(Carry) 	NC(No Carry)
#define FLAG_PF 2 // Parity flag 	Status 	PE(Parity Even) 	PO(Parity Odd)
#define FLAG_AF 4 // Auxiliary Carry flag[4] 	Status 	AC(Auxiliary Carry) 	NA(No Auxiliary Carry)
#define FLAG_ZF 6 // Zero flag 	Status 	ZR(Zero) 	NZ(Not Zero)
#define FLAG_SF 7 // Sign flag 	Status 	NG(Negative) 	PL(Positive)

// "CF", 	# Carry flag 	Status 	CY(Carry) 	NC(No Carry)
// "—" ,	# Reserved, always 1 in EFLAGS [2][3] 	—
// "PF", 	# Parity flag 	Status 	PE(Parity Even) 	PO(Parity Odd)
// "—" ,	# Reserved[3] 	—
// "AF", 	# Auxiliary Carry flag[4] 	Status 	AC(Auxiliary Carry) 	NA(No Auxiliary Carry)
// "—" ,	# Reserved[3] 	—
// "ZF", 	# Zero flag 	Status 	ZR(Zero) 	NZ(Not Zero)
// "SF", 	# Sign flag 	Status 	NG(Negative) 	PL(Positive)
// "TF", 	# Trap flag (single step) 	Control
// "IF", 	# Interrupt enable flag 	Control 	EI(Enable Interrupt) 	DI(Disable Interrupt)
// "DF", 	# Direction flag 	Control 	DN(Down) 	UP(Up)
// "OF", 	# Overflow flag 	Status 	OV(Overflow) 	NV(Not Overflow)
// 
// "IOPL", 	#I/O privilege level (286+ only),always all-1s on 8086 and 186 	System
// "NT", 	#Nested task flag (286+ only),always 1 on 8086 and 186 	System
// "MD", 	#Mode flag (NEC V-series only),[5] reserved on all Intel CPUs.



struct StdOutSwitch {
    int saved_stdout;
    int out_pipe[2];
};
typedef struct StdOutSwitch StdOutSwitch;

char buffer[SIZE] = {0};
StdOutSwitch stdout_switch;

StdOutSwitch change_stdout(int pipe_write) {
    fflush(stdout); //clean everything first

    StdOutSwitch stdout_switch;
    stdout_switch.saved_stdout = dup(STDOUT_FILENO);
    if( pipe(stdout_switch.out_pipe) != 0 ) {          /* make a pipe */
        exit(1);
    }
    if (pipe_write > 0) {
        stdout_switch.out_pipe[1] = pipe_write;
    }

	dup2(stdout_switch.out_pipe[1], STDOUT_FILENO); 
    return stdout_switch;
}

void restore_stdout(StdOutSwitch stdout_switch) {
    close(stdout_switch.out_pipe[1]);
    fflush(stdout);

    dup2(stdout_switch.saved_stdout, STDOUT_FILENO);
}

void read_buffer(StdOutSwitch stdout_switch, char* buffer, size_t count) {
    read(stdout_switch.out_pipe[0], buffer, count); 
}

StdOutSwitch change_stdout_to_buffer() {
    printf("Change stdout to buffer\n");
    return change_stdout(0);
}

StdOutSwitch change_stdout_to_file(char* filename) {
    printf("Change stdout to file %s\n", filename);
    int pt_file = open(filename, O_CREAT|O_TRUNC|O_WRONLY, 0644);
    if (pt_file < 0) {
		perror(filename);	/* open failed */
		exit(1);
	}
    return change_stdout(pt_file);
}

int extract_flag(char* flags, int flag) {
    return flags[flag] == '1' ? 1 : 0;
}

void print_values(char* lines) {

    char* delimiters = "\n";
    char* line = NULL;
    while ((line = strsep(&lines, delimiters)) != NULL) {
        printf("Line: %s\n", line);
        {
            char* cells = line;
            char* delimiters = "|"; 
            char* cell = strsep(&cells, delimiters);
            
            printf("       ");
            while ((cell = strsep(&cells, delimiters)) != NULL) {
                //printf("  - %s\n", cell);
                printf("%s ", cell);
            }
            printf("\n");
        }
    }
}

int print_execution(FILE* fptr, char* buffer) {
    fprintf(fptr, "\n.Instructions executed\n[options=\"autowidth,header\"]\n|====\n^| Instruction ^| RAX ^| RDI ^| Carry ^| Auxillary +\nCarry ^| Parity ^| Zero ^| Sign \n\n");
    {
        char* lines = strdup(buffer);

        char* delimiters = "\n";
        char* line = NULL;
        while ((line = strsep(&lines, delimiters)) != NULL) {
            char* cells = line;
            char* delimiters = "|"; 
            char* cell = strsep(&cells, delimiters);
            
            int column = 0;
            while ((cell = strsep(&cells, delimiters)) != NULL) {
                column++;
                if (column == COLUMN_INSTRUCTION) {
                    fprintf(fptr, "| %s ", cell); 
                } else if (column == COLUMN_RAX) {
                    fprintf(fptr, "| %s ", cell); 
                } else if (column == COLUMN_RDI) {
                    fprintf(fptr, "| %s ", cell); 
                } else if (column == COLUMN_FLAGS) {
                    //fprintf(fptr, "| %s | | | | ", cell); 
                    fprintf(fptr, "^| %d ^| %d ^| %d ^| %d ^| %d ",                         
                        extract_flag(cell, FLAG_CF),
                        extract_flag(cell, FLAG_PF),
                        extract_flag(cell, FLAG_AF),
                        extract_flag(cell, FLAG_ZF),
                        extract_flag(cell, FLAG_SF)
                        ); 
                }
            }
            fprintf(fptr, "\n");
        }
    }
    fprintf(fptr, "|====\n");
}


TEST void test_pass_param_redirect_to_file() {

    stdout_switch = change_stdout_to_file("../work/target/doc.txt");

    printf("if_equals_10(9): %d\n", if_equals_10(9));
    _assertIntEq(0, if_equals_10(9));
    _assertIntEq(1, if_equals_10(10));

    restore_stdout(stdout_switch);

}


TEST void test_pass_param_redirect_to_buffer() {
    {
        stdout_switch = change_stdout_to_buffer();
        
        _assertIntEq(0, if_equals_10(9));
        
        restore_stdout(stdout_switch);
        read_buffer(stdout_switch, buffer, SIZE); 
        printf("\n>>>%s<<<\n", buffer);
        printf("Size: %zu\n", strlen(buffer));
    }

    {
        stdout_switch = change_stdout_to_buffer();
        
        _assertIntEq(1, if_equals_10(10));
        
        restore_stdout(stdout_switch);
        read_buffer(stdout_switch, buffer, SIZE); 
        printf("\n>>>%s<<<\n", buffer);
        printf("Size: %zu\n", strlen(buffer));


        print_values(buffer);
    }
}



TEST void test_if_equals_no_redirect_stdout() {

    printf("if_equals_10(9): %d\n", if_equals_10(9));
    _assertIntEq(0, if_equals_10(9));
    _assertIntEq(1, if_equals_10(10));

}


TEST void test_document_if_equals() {
    // Redirect output
    stdout_switch = change_stdout_to_buffer();
    
    // Execution
    int input_value = 10;
    int result = if_equals_10(input_value);
    
    // Restore output
    restore_stdout(stdout_switch);
    read_buffer(stdout_switch, buffer, SIZE); 
   
    // Format document
    char* filename = "../work/target/if_equals.adoc";
    printf("Change stdout to file %s\n", filename);
    FILE* fptr = fopen(filename, "w");
    {
        fprintf(fptr, ":SOURCE_PATH: ../../examples/spike/doc\n");
        fprintf(fptr, "= Comparators\n");

        fprintf(fptr, "\nCall function: +\n`if_equals_10(%d)` -> `%d`\n", input_value, result);
        
        fprintf(fptr, "\n[%%collapsible]\n.Code .asm\n====\n----\ninclude::{SOURCE_PATH}/demo_if.asm[tag=if_equals_10]\n\ninclude::{SOURCE_PATH}/demo_if.asm[tag=common]\n----\n====\n");

        print_execution(fptr, buffer);

        fprintf(fptr, "`RAX` may contain the input value but we have to read it from `RDI`.\n");
        fprintf(fptr, "After the comparison, the flag `Zero` is `1` when values are equal.");
        fprintf(fptr, "In that case, the `je` is activated and the jump is made.");
    }
    fclose(fptr);
}

RUN_TESTS()