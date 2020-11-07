#ifndef TEST_H_   /* Include guard */
#define TEST_H_

#include <stdio.h>
#include <string.h>

#define SHELL_COLOR

#ifdef SHELL_COLOR
#define SHELL_RED printf("\033[0;31m");
#define SHELL_GREEN printf("\033[0;32m");
#define SHELL_NO_COLOR printf("\033[0m");
#else
#define SHELL_RED
#define SHELL_GREEN
#define SHELL_NO_COLOR
#endif

int tests_run = 0;
int tests_failed = 0;
int isFailed=0;

#define FAIL() \
    SHELL_RED \
    tests_failed++; \
    isFailed=1; \
    printf("Failure in %s() line %d", __func__, __LINE__)

#define _assert(test) \
    do { \
        if (!(test)) { \
            FAIL(); \
            return; \
        } \
    } while(0)

#define _assertNumberEq(expected, actual, message) \
    do { \
        if (!(expected == actual)) { \
            FAIL(); \
            printf(message, expected, actual); \
            return; \
            } \
    } while(0)

#define _assertCharEq(expected, actual) _assertNumberEq((int)expected, (int)actual, ", Expected: %d but was: %d")
#define _assertIntEq(expected, actual) _assertNumberEq(expected, actual, ", Expected: %d but was: %d")
#define _assertInt64Eq(expected, actual) _assertNumberEq(expected, actual, ", Expected: %ld but was: %ld")

#define _assertStringEq(expected, actual) \
    do { \
        char* actualValue=actual; \
        if (strcmp(expected, actualValue)!=0) { \
            FAIL(); \
            printf(", Expected: %s but was: %s", expected, actualValue);return; \
        } \
    } while(0)

#define _verify(test) \
    do { \
        tests_run++; \
        test(); \
        SHELL_NO_COLOR \
    } while(0)

#define _verifyWithName(test, name) \
    do { \
        tests_run++; \
        isFailed=0; \
        printf("%s: ", name); \
        test(); \
        SHELL_GREEN \
        printf("%s\n", isFailed?"":"Success"); \
        SHELL_NO_COLOR \
    } while(0)

#define TEST

/*void all_tests() {} int main(int argc, char **argv) { all_tests(); return runTests(); }*/
#define RUN_TESTS()

int reportTests() {
    if (tests_failed == 0)
    {
        SHELL_GREEN
        printf("-------------\n");
        printf("PASSED\n");
    }
    else
    {
        SHELL_RED
        printf("-------------\n");
        printf("FAILED\n");
    }
    printf("-------------\n");
    printf("Tests run: %d\nTests failed:%d\n", tests_run,tests_failed);
    SHELL_NO_COLOR
    return tests_failed == 0;
}

#endif // TEST_H_


