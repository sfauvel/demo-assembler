#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int add_5(int);



void read_from_file(char* filename, char* buffer, int max_size) {
    FILE *file = fopen(filename, "r");
 
    if(file==NULL){
        printf("Erreur lors de l'ouverture d'un fichier");
        exit(1);
    }
 
    int char_in_buffer = 0;
    while( fgets(buffer+char_in_buffer, max_size-char_in_buffer, file) != NULL) {
        char_in_buffer = strlen(buffer);
        if (char_in_buffer + 1 >= max_size) break;
    }

    fclose(file);
}

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
    printf("\n"); // To flush stdout
    
    stdout_switch.saved_stdout = dup(1);
	dup2(stdout_switch.new_stdout, 1); 
    return stdout_switch;
}

void restore_stdout(StdOutSwitch stdout_switch) {
    close(stdout_switch.new_stdout);
    dup2(stdout_switch.saved_stdout, 1);
}

int main(int argc, char **argv) {
  /*  {
        setbuf(stdout, NULL); // Disable buffering on stdout
        
        printf("[%%autowidth]\n|====\n");
        printf("| command | rax | rcx | rdi | rsi | rdx | r8 | r9 | r10 | r11 | rsp  \n\n");
        int result = add_5(7);
        printf("|====\n");
        printf("Result:%d\n", result);
    }*/
    {
      /*
       char buffer[1024] = {0};
        printf("======================");
        StdOutSwitch stdout_switch = change_stdout(buffer);

        int result = add_5(7);

        restore_stdout(stdout_switch);
        printf("======================");
        printf("%s", buffer);
        printf("======================");
        */
        char* filename = "tmp.adoc";
        StdOutSwitch stdout_switch =  change_stdout(filename);

        int result = add_5(7);
        printf("Result:%d\n", result);

        restore_stdout(stdout_switch);

    }
}