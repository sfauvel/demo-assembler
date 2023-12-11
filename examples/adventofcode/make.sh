#!/usr/bin/env bash

export FILE=day1
export ASM_PATH=examples/adventofcode
export TEST_PATH=examples/adventofcode

start=$(date +%s%N)
../../scripts/make.sh $*

end=$(date +%s%N)

#echo "Elapsed time: $(($end-$start)) ns"
echo "Elapsed time: $(($(($end-$start))/1000000)) ms"

# For nasm, it takes approximatively 150ms (between 100 to 200ms)
# The real execution (with compiling) takes less than 10ms (launch day1.test.o) 
# When we run test several times, each execution takes 2ms. 
# With rust, when it recompiles (no target folder), it takes approximatively 450ms (with cargo test)
# The execution only (with target folder kept), takes 100ms (sometime, less than 80ms)
# We do not have test on the complete example from a file but it only add 20ms to the exectution in Rust