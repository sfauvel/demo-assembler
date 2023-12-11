

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

#include <demo_if.h>
#include <demo_inner_function.h>
#include <demo_file.h>
#include <demo_macro.h>
#include <demo_method.h>
#include <demo_param.h>
#include <demo_string.h>
#include <demo_variable.h>
#include <demo_perf.h>


TEST void test_pass_param() {
    _assertIntEq(321, param_sum_param(1, 20, 300));
}

TEST void test_return_2() {
    _assertIntEq(2, method_return_2());
}

TEST void test_return_3() {
    _assertIntEq(3, method_return_3());
}

TEST void test_if_greater_than() {
    _assertIntEq(0, if_greater_than_10(9));
    _assertIntEq(0, if_greater_than_10(10));
    _assertIntEq(1, if_greater_than_10(11));
}

TEST void test_if_lower_than() {
    _assertIntEq(1, if_lower_than_10(9));
    _assertIntEq(0, if_lower_than_10(10));
    _assertIntEq(0, if_lower_than_10(11));
}

TEST void test_if_equals() {
    _assertIntEq(0, if_equals_10(9));
    _assertIntEq(1, if_equals_10(10));
    _assertIntEq(0, if_equals_10(11));
}

TEST void test_using_inner_function() {
    _assertIntEq(543, inner_function_return_543());
}

TEST void test_function_using_stack_with_local_stack() {
    _assertIntEq(658, inner_function_using_stack_return_658());
}

TEST void test_function_using_stack() {
    _assertIntEq(764, inner_function_using_stack_return_764());
}

TEST void test_pass_string_param() {
    _assertStringEq("hello", string_get_param("hello"));
}

TEST void test_substring_from() {
    _assertStringEq("lo", string_substring_from("hello", 3));
}

TEST void test_variable() {
    _assertIntEq(42, variable_return(42));
}

/////////////
// Demo_macro
TEST void test_macro_constant() {
    _assertIntEq(42, macro_return_42());
}

TEST void test_macro() {
    _assertIntEq(42, macro_set_variable_to_42());
}

////////////
// Demo file
TEST void test_read_file() {
    FILE* file = fopen("../work/target/demo_read_data.txt", "w");
    fprintf(file, "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    fclose(file);

    _assertStringEq("ABCDEFGHIJKLMNOPQRSTUVWXYZ", read_file_to_buffer());
}

#define TAILLE_MAX 1024
TEST void test_write_file() {
    
    write_hard_coded_file_with_alphabet();

    char buffer[TAILLE_MAX] = "";
    FILE* file = fopen("../work/target/demo_write_data.txt", "r");
    fgets(buffer, TAILLE_MAX, file);
    fclose(file);

    _assertStringEq("ABCDEFGHIJKLMNOPQRSTUVWXYZ", buffer);
}

TEST void test_write_file_with_param() {
    
    write_given_file_with_alphabet("../work/target/demo_write_data_param.txt");

    char buffer[TAILLE_MAX] = "";
    FILE* file = fopen("../work/target/demo_write_data_param.txt", "r");
    fgets(buffer, TAILLE_MAX, file);
    fclose(file);

    _assertStringEq("ABCDEFGHIJKLMNOPQRSTUVWXYZ", buffer);
}

////////////
// Demo perf

TEST void test_perf() {
    {
        int result = short_method();
        long duration = 0;
        int result_with_measure = measure_perf_short_method(&duration);

        _assertIntEq(result, result_with_measure);
        _assert(duration > 0);
        _assert(duration < 100);
    }
    {
        int result = long_method();
        long duration = 0;
        int result_with_measure = measure_perf_long_method(&duration);

        _assertIntEq(result, result_with_measure);
        _assert(duration > 500);
        _assert(duration < 5000);
    }
}

//void read_from_file(char* filename, char* buffer, int max_size) {
//    FILE *file = fopen(filename, "r");
// 
//    if(file==NULL){
//        printf("Erreur lors de l'ouverture d'un fichier");
//        exit(1);
//    }
// 
//    int char_in_buffer = 0;
//    while( fgets(buffer+char_in_buffer, max_size-char_in_buffer, file) != NULL) {
//        char_in_buffer = strlen(buffer);
//        if (char_in_buffer + 1 >= max_size) break;
//    }
//
//    fclose(file);
//}
//
//struct StdOutSwitch {
//    int saved_stdout;
//    int new_stdout;
//};
//typedef struct StdOutSwitch StdOutSwitch;
//
//StdOutSwitch change_stdout(char* filename) {
//    StdOutSwitch stdout_switch;
//
//    if ((stdout_switch.new_stdout = open(filename, O_CREAT|O_TRUNC|O_WRONLY, 0644)) < 0) {
//		perror(filename);	/* open failed */
//		exit(1);
//	}
//    printf("\n"); // To flush stdout
//    
//    stdout_switch.saved_stdout = dup(1);
//	dup2(stdout_switch.new_stdout, 1); 
//    return stdout_switch;
//}
//
//void restore_stdout(StdOutSwitch stdout_switch) {
//    close(stdout_switch.new_stdout);
//    dup2(stdout_switch.saved_stdout, 1);
//}
//
// TEST void test_write_number_in_stdout() {
//     char* filename = "tmp.txt";
//     StdOutSwitch stdout_switch =  change_stdout(filename);
// 
//     display_number(123);
// 
//     restore_stdout(stdout_switch);
//     
//     int MAX_SIZE=20;
//     char str[MAX_SIZE];
//     read_from_file(filename, str, MAX_SIZE);
// 
//     _assertStringEq("Number: 123\n", str);
// }

//TEST void test_write_text_in_stdout() {
//    char* filename = "tmp.txt";
//    StdOutSwitch stdout_switch =  change_stdout(filename);
//
//    display_text("abc");
//
//    restore_stdout(stdout_switch);
//    
//    int MAX_SIZE=20;
//    char str[MAX_SIZE];
//    read_from_file(filename, str, MAX_SIZE);
//
//    _assertStringEq("Text: abc\n", str);
//}

//TEST void test_write_text_in_stdout_full_asm() {
//   // char* filename = "tmp.txt";
//   // StdOutSwitch stdout_switch =  change_stdout(filename);
////
//    debug_text_asm("abc");
//    //display_text_asm("abc");
////
//   // restore_stdout(stdout_switch);
//   // 
//   // int MAX_SIZE=20;
//   // char str[MAX_SIZE];
//   // read_from_file(filename, str, MAX_SIZE);
////
//   // _assertStringEq("Text: abc\n", str);
//}
//
//TEST void test_print_registry_stdout() {
//    char* filename = "tmp.adoc";
//    StdOutSwitch stdout_switch =  change_stdout(filename);
//
//    _assertIntEq(25, my_method(5, 7, 13));
//
//    restore_stdout(stdout_switch);
//}

//TEST void test_debug_prog() {
//    char* filename = "debug.adoc";
//    StdOutSwitch stdout_switch =  change_stdout(filename);
//
//    _assertIntEq(25, algo_to_debug_Y(5, 7, 13));
//
//    restore_stdout(stdout_switch);
//    
//}

RUN_TESTS()