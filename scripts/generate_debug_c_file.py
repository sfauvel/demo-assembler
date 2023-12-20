# from ctypes import *
# so_file = "../../target/demo_xxx.so"
# my_functions = CDLL(so_file)

# Add instructions between each lines to trace register values
import os
import re



def generate_c_file():
    lines =[]
    print(f"{PROJECT_PATH}/{DEMO}.c")
    with open(f"{PROJECT_PATH}/{DEMO}.c", "r") as input:
        for line in input:
            # print(line.rstrip())
            lines.append(line.replace("int main(int argc, char **argv)","int original_main(int argc, char **argv)"))

    os.makedirs(DEBUG_PATH, exist_ok=True )
    
    with open(f"{DEBUG_PATH}/{DEMO}.debug.c", "w") as output:
        output.write("".join(lines))
        
        output.write("""

#include <stdlib.h>  // Need for debug: exit
#include <fcntl.h>   // Need for debug: O_CREAT, O_TRUNC, ...
#include <unistd.h>  // Need for debug: dup, dup2, close

struct StdOutSwitch {
    int saved_stdout;
    int new_stdout;
};
typedef struct StdOutSwitch StdOutSwitch;

StdOutSwitch change_stdout(char* filename) {
    StdOutSwitch stdout_switch;

    if ((stdout_switch.new_stdout = open(filename, O_CREAT|O_TRUNC|O_WRONLY, 0644)) < 0) {
		perror(filename);	/* open failed */
		exit(1);
	}
    printf("\\n"); // To flush stdout
    
    stdout_switch.saved_stdout = dup(1);
	dup2(stdout_switch.new_stdout, 1); 
    return stdout_switch;
}

void restore_stdout(StdOutSwitch stdout_switch) {
    close(stdout_switch.new_stdout);
    dup2(stdout_switch.saved_stdout, 1);
}

                     
int main(int argc, char **argv) {
    char* debug_file = argv[1];
    printf("File %s\\n", debug_file);
    StdOutSwitch stdout_switch =  change_stdout(debug_file);

    original_main(argc, argv);

    restore_stdout(stdout_switch);
}
                     """)

import sys
if __name__ == "__main__":
    if (len(sys.argv)<=3):
        raise "Too few arguments"
    PROJECT_PATH=sys.argv[1]
    DEMO=sys.argv[2]
    DEBUG_PATH=sys.argv[3]
   
    print(f"PROJECT_PATH:{PROJECT_PATH}")
    print(f"DEMO:{DEMO}")
    print(f"DEBUG_PATH:{DEBUG_PATH}")
    generate_c_file()