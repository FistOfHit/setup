#!/bin/bash

set -uo pipefail

# Configuration
NUM_GPUS=TODO # Unbound var, should error if not fixed

# Test Hyperparameters
MIN_BYTES=2M
MAX_BYTES=16G
STEP_FACTOR=2
ITERATIONS=100

# Function to run a single benchmark
run_benchmark() {
    local benchmark=$1
    echo "Running $benchmark benchmark..."
    ./build/${benchmark}_perf \
        --minbytes $MIN_BYTES \
        --maxbytes $MAX_BYTES \
        --stepfactor $STEP_FACTOR \
        --ngpus $NUM_GPUS \
        --iters $ITERATIONS \
        --op all | tee -a ../${benchmark}_benchmark.log
    echo "$benchmark benchmark completed."
    echo
}

echo "Starting NCCL benchmarks with $NUM_GPUS GPUs"
echo

# List of NCCL benchmarks
BENCHMARKS=(
    "all_reduce"
    "all_gather"
    "broadcast"
    "reduce_scatter"
    "reduce"
    "alltoall"
    "scatter"
    "gather"
    "sendrecv"
    "hypercube"
)

# Iterate through all benchmarks
cd ./nccl-tests
for benchmark in "${BENCHMARKS[@]}"; do
    if [ -f "./build/${benchmark}_perf" ]; then
        run_benchmark "$benchmark"
    else
        echo "Warning: ${benchmark}_perf not found in ./build directory. Skipping."
    fi
done
cd - > /dev/null

echo "All benchmarks completed."

set +uo pipefail
