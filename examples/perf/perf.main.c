#include <stdio.h>
#include <inttypes.h>
#include <limits.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int run_perf_with_parameter(unsigned long* duration);
unsigned long run_perf_return_value();

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

int main(int argc, char **argv) {
   run_with_duration_return_from_the_method();
   run_with_duration_passing_as_parameter_to_the_method();
   iterate_to_compute_average_time();
}