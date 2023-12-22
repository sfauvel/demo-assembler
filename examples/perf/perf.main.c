#include <stdio.h>
#include <inttypes.h>
#include <limits.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int run_perf_with_parameter(unsigned long* duration);
unsigned long run_perf_return_value();
void method_to_monitor();

char* read_file_to_buffer();
char* read_file_char_by_char();
char* read_file_by_blocks();
void do_nothing();                       //  0.0000018ms
void empty_loop();                       //  0.0000024ms
void loop_of_1000();                     //  0.001080ms
void jmp_do_nothing_1000_loop();         //  0.001636ms
void call_do_nothing_1000_loop();        //  0.001885ms
void call_do_nothing_1000_manual_loop(); //  0.001420ms
void jmp_if_else_1000_loop(int);         //  (1):0.001960ms  (0)0.001680ms
void variable_mov_1000_loop();           //  0.00139ms  // Very few difference between register and variable
void register_mov_1000_loop();           //  0.00139ms 

////////
// Define the method to call for monitoring perf
#define CALL_METHOD_TO_MONITOR register_mov_1000_loop()
///////

void run_with_duration_return_from_the_method() {
   unsigned long result = run_perf_return_value();
   printf("run_perf_return_value\n");
   printf("    Returned duration %lu\n", result);
}

void run_with_duration_passing_as_parameter_to_the_method() {
      unsigned long result = 0;
      int returned_value = run_perf_with_parameter(&result);
      printf("run_perf_with_parameter\n");
      printf("    Returned value  %d\n", returned_value);
      printf("    Returned duration %lu\n", result);
}

void iterate_to_compute_average_time() {
   unsigned long total=0;
   unsigned long nb_iteration=0;
   while (1) {   
      nb_iteration++;

      unsigned long result = 0;
      
      result = run_perf_return_value();

      total+=result;   
      // printf("%ul / %ul / %d \n", total, ULONG_MAX, INT_MAX);
      if (total > INT_MAX) {  // LONG_MAX is half of ULONG_MAX
         printf("%.2f cycles, (%ld iterations)\n", (float)total/(float)nb_iteration, nb_iteration);
         total = 0;
         nb_iteration = 0;
      }
   }

}



#define CYCLES_PER_SEC(ghz)     ((ghz) * 1e9)
#define CYCLES_PER_MSEC(ghz)    ((ghz) * 1e6)
#define CYCLES_PER_USEC(ghz)    ((ghz) * 1e3)
#define GHZ 2.8 // Frequency of my computer : `cat /proc/cpuinfo | grep Hz`



double iteration_calibration_for_one_second(const int iteration_for_calibration) {
   time_t start_clock_calibration = clock();
    for (int i=0; i<iteration_for_calibration; i++) {
       CALL_METHOD_TO_MONITOR;
    }
    time_t end_clock_calibration = clock();
    unsigned long duration_clock_calibration = end_clock_calibration - start_clock_calibration;
   
    double iterations_in_1_second = 1e6*iteration_for_calibration/duration_clock_calibration;
    return iterations_in_1_second;
}

void iterate_to_compute_average_time_from_c() {

   unsigned long  NB_ITERATION_MAX = iteration_calibration_for_one_second(1000)*5;
   // unsigned long  NB_ITERATION_MAX = 1000*1000;
   
   unsigned long nb_iteration=0;
   time_t start_clock = clock();
   struct timeval stop_time, start_time;
   gettimeofday(&start_time, NULL);

   // Clock => number of ticks of a process (pause are not counted)
   // Time => real time
   //printf("%lu clock time, %f\n",duration_clock_calibration, (double)1e6/(double)duration_clock_calibration*nb_iteration_calibration);   
   printf("Nb iteration: %lu \n",NB_ITERATION_MAX);

   time_t t;   // not a primitive datatype
   while (1) {   
      nb_iteration++;

      CALL_METHOD_TO_MONITOR;
      
      if (nb_iteration >= NB_ITERATION_MAX) { 
         time_t end_clock = clock();
         time(&t);
         gettimeofday(&stop_time, NULL);
   
         unsigned long duration_time =(stop_time.tv_sec - start_time.tv_sec) * 1000000 + (stop_time.tv_usec - start_time.tv_usec);
         unsigned long duration_clock = end_clock - start_clock;

         //  printf("%ld %s\n", end-start, ctime(&t));
         printf("%.2f clocks, clock:%.9fms, time:%.9fms, (%ld iterations - %.3fs)\n", (double)duration_clock/(double)nb_iteration*CYCLES_PER_USEC(GHZ), (double)duration_clock/(double)nb_iteration/1000.0, (double)duration_time/(double)nb_iteration/1000.0, nb_iteration, (double)duration_time / 1e6);
         
         nb_iteration = 0;
         start_clock = end_clock;
         start_time = stop_time;
      }
   }
}

void run_read_all_file_with_one_call() {
   const char* x = read_file_to_buffer();
   printf("%s", x);
}

void run_read_file_char_by_char() {
   
   const char* x = read_file_char_by_char();
   printf("%s", x);
   
}


int main(int argc, char **argv) {
   system( "cp ../examples/perf/perf_file.asm ../work/target/demo_read_data.txt");
   
   //run_with_duration_return_from_the_method();
   //run_with_duration_passing_as_parameter_to_the_method();
   //iterate_to_compute_average_time();
   iterate_to_compute_average_time_from_c();

   //run_read_all_file_with_one_call();
   //run_read_file_char_by_char();
   
   
}