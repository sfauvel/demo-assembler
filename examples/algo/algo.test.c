

/* runner.c */

#include <stdio.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

#include <test.h>

#include <stdlib.h>
#include <stdio.h>
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

TEST void test_print_registry_stdout() {
    char* filename = "tmp.adoc";
    StdOutSwitch stdout_switch =  change_stdout(filename);

    _assertIntEq(25, add_5(20));

    restore_stdout(stdout_switch);
}



RUN_TESTS()