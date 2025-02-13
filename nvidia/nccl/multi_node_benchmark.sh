#!/bin/bash

set -uo pipefail

# Hostfile path
HOSTFILE=/home/dell/hostfile.txt # Unbound var, should error if not fixed

# Configuration
NUM_NODES=TODO # Unbound var, should error if not fixed
NUM_GPUS_PER_NODE=TODO # Unbound var, should error if not fixed
NUM_GPUS=$((NUM_NODES * NUM_GPUS_PER_NODE))

# Test Hyperparameters
MIN_BYTES=2M
MAX_BYTES=16G
STEP_FACTOR=2
ITERATIONS=100

# Function to run a single benchmark
run_benchmark() {
    local benchmark=$1
    echo "Running $benchmark benchmark..."

    # Replace TODO with the interface of the network you want to use 
    # --ngpus for the benchmark is set to 1 now as we are running on 1 GPU per process,
    # MPI handles the multiprocessing above
    mpirun \
        --mca btl_tcp_if_include TODO \
        -np $NUM_GPUS \
        -npernode $NUM_GPUS_PER_NODE \
        --hostfile $HOSTFILE \
        ./build/${benchmark}_perf \
            --minbytes $MIN_BYTES \
            --maxbytes $MAX_BYTES \
            --stepfactor $STEP_FACTOR \
            --ngpus 1 \
            --iters $ITERATIONS \
            --op all | tee -a ../${benchmark}_benchmark.log
    echo "$benchmark benchmark completed."
    echo
}

echo "Starting NCCL benchmarks with $NUM_GPUS GPUs ($NUM_NODES nodes, $NUM_GPUS_PER_NODE GPUs per node)"
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
