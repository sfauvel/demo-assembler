#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <day1.h>

void display_perf(const int nb_iterations, const char* text) {

    float total_duration = 0.0;

    for (int i=0; i<nb_iterations; i++) {
        long duration = 0;
        int result = sum_of_lines_timer(text, &duration);        
        total_duration += duration;
    }
    printf("Result:%f cycle times for %d iterations\n", total_duration/(float)nb_iterations, nb_iterations);
}


void compute_from_file() {
    FILE *f;
    char c;
    char buffer[50000];
    f=fopen("../examples/adventofcode/input.txt","rt");
    int index = 0;
    while((c=fgetc(f))!=EOF){
        printf("%c",c);
        buffer[index] = c;
        index++;
    }
    fclose(f);
    buffer[index] = 0;
    printf("[%s]\n", buffer);
    int result = calibration_from_buffer(buffer);
    printf("Result=%d (should be 55172)\n", result);
}

void compute_example(const char* text) {    
    int result = calibration_from_buffer(text);
    printf("Text:%s\n", text);
    printf("Result:%d\n", result);
}

void compute_perf() {
    //const char* text = "1abc3";
    const char* text = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet";
    
    compute_example(text);

    int factor = 1;
    for (int i=0; i<=6; i++) {
        display_perf(factor, text);
        factor*=10;
    }
}


int main(int argc, char **argv) {
    //compute_example("1abc3");
    compute_example("abc");

    compute_perf();

    //compute_from_file();
}