#!/bin/bash

set -euo pipefail

MPI_HOME=TODO
CUDA_HOME=TODO
NCCL_HOME=TODO

# Check if all TODOs have been replaced
if grep -q "TODO" "$0"; then
    echo "Please replace all TODOs in this script before running it."
    exit 1
fi

# Check if MPI is installed and available
if [ ! -d "$MPI_HOME" ]; then
    echo "Error: MPI not found at $MPI_HOME."
    exit 1
fi

# Check if CUDA is installed and available
if [ ! -d "$CUDA_HOME" ]; then
    echo "Error: CUDA not found at $CUDA_HOME."
    exit 1
fi

# Check if NCCL is installed and available
if [ ! -d "$NCCL_HOME" ]; then
    echo "Error: NCCL not found at $NCCL_HOME."
    exit 1
fi

# Clone and build tests
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests

make MPI=1 MPI_HOME=$MPI_HOME CUDA_HOME=$CUDA_HOME NCCL_HOME=$NCCL_HOME

# Return to original directory
cd - > /dev/null
