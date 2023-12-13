#include <stdio.h>
#include <inttypes.h>
#include <limits.h>
#include <string.h>

#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int run_perf_with_parameter(unsigned long* duration);
unsigned long run_perf_return_value();


int main(int argc, char **argv) {
   {
      unsigned long result = run_perf_return_value();
      printf("run_perf_return_value\n");
      printf("    Returned duration %lu\n", result);
   }
   {
      unsigned long result = 0;
      int returned_value = run_perf_with_parameter(&result);
      printf("run_perf_with_parameter\n");
      printf("    Returned value  %d\n", returned_value);
      printf("    Returned duration %lu\n", result);
   }

   unsigned long total=0;
   unsigned long nb_iteration=0;
   while (1) {   
      nb_iteration++;

      unsigned long result = 0;
      result = run_perf_return_value();
      //run_perf_with_parameter(&result);
      total+=result;   
      // printf("%ul / %ul / %d \n", total, ULONG_MAX, INT_MAX);
      if (total > INT_MAX) {  // LONG_MAX is half of ULONG_MAX
         printf("%.2f cycles, (%ld iterations)\n", (float)total/(float)nb_iteration, nb_iteration);
         total = 0;
         nb_iteration = 0;
      }
   }
}