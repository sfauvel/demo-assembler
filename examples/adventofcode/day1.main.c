#include <stdio.h>
#include <inttypes.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>

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

#define CYCLES_PER_SEC(ghz)     ((ghz) * 1e9)
#define CYCLES_PER_MSEC(ghz)    ((ghz) * 1e6)
#define CYCLES_PER_USEC(ghz)    ((ghz) * 1e3)
#define GHZ 2.8 // Frequency of my computer : `cat /proc/cpuinfo | grep Hz`

void iterate_to_compute_average_time_from_c(const char* filename) {
    const unsigned long  NB_ITERATION_MAX = 1000;
    unsigned long nb_iteration=0;
    time_t start_clock = clock();
    struct timeval stop_time, start_time;
    gettimeofday(&start_time, NULL);

    // Clock => number of ticks of a process (pause are not counted)
    // Time => real time

    time_t t;   // not a primitive datatype
    while (1) {   
        nb_iteration++;
  
        calibration_from_file(filename);
        
        if (nb_iteration >= NB_ITERATION_MAX) { 
            time_t end_clock = clock();
            time(&t);
            gettimeofday(&stop_time, NULL);
    
            unsigned long duration_time =(stop_time.tv_sec - start_time.tv_sec) * 1000000 + (stop_time.tv_usec - start_time.tv_usec);
            unsigned long duration_clock = end_clock - start_clock;

            //  printf("%ld %s\n", end-start, ctime(&t));
            printf("%.0f clocks, clock:%.2fms, time:%.2fms, (%ld iterations - %.3fs)\n", (double)duration_clock/(double)nb_iteration*CYCLES_PER_USEC(GHZ), (double)duration_clock/(double)nb_iteration/1000.0, (double)duration_time/(double)nb_iteration/1000.0, nb_iteration, (double)duration_time / 1e6);
           
            nb_iteration = 0;
            start_clock = end_clock;
            start_time = stop_time;
        }
   }

}


int main(int argc, char **argv) {
    //compute_example("1abc3");
    compute_example("abc");

    //compute_perf_from_buffer();
    //compute_perf_from_file();
     //iterate_to_compute_average_time_from_c("../examples/adventofcode/input_short.txt");
    iterate_to_compute_average_time_from_c("../examples/adventofcode/input.txt");

    //compute_from_file();
}