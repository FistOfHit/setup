#!/bin/bash

set -euo pipefail

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

# Configuration
NUM_NODES=TODO
NUM_GPUS_PER_NODE=TODO
NUM_GPUS=$((NUM_NODES * NUM_GPUS_PER_NODE))

# Check all TODOs have been replaced
if grep -q "TODO" "$0"; then
    echo "Please replace all TODOs in this script before running it."
    exit 1
fi

# Test Hyperparameters
MIN_BYTES=${MIN_BYTES:-8}
MAX_BYTES=${MAX_BYTES:-8M}
STEP_FACTOR=${STEP_FACTOR:-2}
ITERATIONS=${ITERATIONS:-100}
CHECK=${CHECK:-1}

# Function to run a single benchmark
run_benchmark() {
    local benchmark=$1
    echo "Running $benchmark benchmark..."
    mpirun -np $NUM_GPUS \
        ./build/${benchmark}_perf \
        --minbytes $MIN_BYTES \
        --maxbytes $MAX_BYTES \
        --stepfactor $STEP_FACTOR \
        --ngpus 1 \
        --check $CHECK \
        --iters $ITERATIONS \
        --op all
    echo "$benchmark benchmark completed."
    echo
}

echo "Starting NCCL benchmarks with $NUM_GPUS GPUs ($NUM_NODES nodes, $NUM_GPUS_PER_NODE GPUs per node)"
echo

# Iterate through all benchmarks
for benchmark in "${BENCHMARKS[@]}"; do
    if [ -f "./build/${benchmark}_perf" ]; then
        run_benchmark "$benchmark"
    else
        echo "Warning: ${benchmark}_perf not found in ./build directory. Skipping."
    fi
done

echo "All benchmarks completed."
