#include <stdio.h>
#include <inttypes.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#include <day1.h>

void display_perf_from_buffer(const int nb_iterations, const char* text) {

    float total_duration = 0.0;

    for (int i=0; i<nb_iterations; i++) {
        long duration = 0;
        int result = calibration_from_buffer_timer(text, &duration);        
        total_duration += duration;
    }
    printf("Result:%.2f cycle times for %d iterations\n", total_duration/(float)nb_iterations, nb_iterations);
}

void display_perf_from_file(const int nb_iterations, const char* filename) {

    float total_duration = 0.0;

    for (int i=0; i<nb_iterations; i++) {
        long duration = 0;
        int result = calibration_from_file_timer(filename, &duration);        
        total_duration += duration;
    }
    printf("Result:%.2f cycle times for %d iterations\n", total_duration/(float)nb_iterations, nb_iterations);
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

void compute_perf_from_buffer() {
    //const char* text = "1abc3";
    const char* text = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet";
    printf("\nCompute from text:%s", text);

    compute_example(text);

    int iteration_with_same_value=5;
    int factor = 1;
    for (int i=0; i<=6; i++) {
        for (int j=0; j<iteration_with_same_value; j++) {
            display_perf_from_buffer(factor, text);
        }
        factor*=10;
    }
}

void compute_perf_from_file() {
    const char* filename = "../examples/adventofcode/input.txt";
    printf("\nCompute from file:%s", filename);
    
    //compute_example(text);

    int iteration_with_same_value=5;
    int factor = 1;
    for (int i=0; i<=6; i++) {
        for (int j=0; j<iteration_with_same_value; j++) {
            display_perf_from_buffer(factor, filename);
        }
        factor*=10;
    }
}

int main(int argc, char **argv) {
    //compute_example("1abc3");
    compute_example("abc");

    compute_perf_from_buffer();
    compute_perf_from_file();

    //compute_from_file();
}