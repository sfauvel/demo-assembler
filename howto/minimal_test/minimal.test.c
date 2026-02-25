/*
* This is a trivial test to show how we can write tests.
*
*/

///////////////////////
// Mini test framework

#include <stdio.h>

int isTestFailed=0;

// We use a define to be able to:
// * trace function name and assertion line.
// * make a return in test function when assertion fail.
#define ASSERT(test) \
    if (!(test)) { \
        isTestFailed=1; \
        printf("Failure in %s() line %d", __func__, __LINE__); \
        return; \
    } \

// Execute a test and display name and result.
void runTest(void (*test)(), char* name) {
    isTestFailed=0;
    printf("%s: ", name);
    test(); 
    printf("%s\n", isTestFailed?"":"Success");
}
// End of mini test framework
///////////////////////

void should_verify_a_simple_addition() {
    ASSERT(1 + 2 == 3);
}

void should_verify_a_simple_substraction() {
    ASSERT(5 - 2 == 3);
}

int main(int argc, char **argv) { 
    runTest(&should_verify_a_simple_addition, "should_verify_a_simple_addition");
    runTest(&should_verify_a_simple_substraction, "should_verify_a_simple_substraction");
}