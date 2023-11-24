#include <stdio.h> 

void display_stack();
void display_flags();
        
// Then there is a flush at the end pf printf command. 
void disable_stdout_buffering() {
    setbuf(stdout, NULL); 
}

int main(int argc, char **argv) {
    disable_stdout_buffering();

    printf("\nDisplay stack:\n  ");
    display_stack();
    printf("\nDisplay flags:\n  ");
    display_flags();
    printf("\n");
}