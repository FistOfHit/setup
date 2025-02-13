#!/bin/bash

set -uo pipefail

# Set default MPI_HOME
MPI_HOME=TODO # Set this to the path of your MPI installation

# Set NCCL paths (adjust these paths based on your system)
export NCCL_HOME=/usr/lib/x86_64-linux-gnu/
export CUDA_HOME=/usr/local/cuda

# Clone and build tests
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests

# Build with additional path information
make MPI=1 \
    MPI_HOME=$MPI_HOME \
    CUDA_HOME=$CUDA_HOME \
    NCCL_HOME=$NCCL_HOME

# Return to original directory
cd - > /dev/null

set +uo pipefail
