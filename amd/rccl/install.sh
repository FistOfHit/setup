#!/bin/bash

set -uo pipefail

# Set default MPI_HOME
MPI_HOME=TODO # Set this to the path of your MPI installation

# Set NCCL paths (adjust these paths based on your system)
export RCCL_HOME=/usr/lib/x86_64-linux-gnu/
export HIP_HOME=/usr/local/hip

# Clone and build tests
git clone https://github.com/ROCm/rccl-tests.git
cd rccl-tests

# Build with additional path information
# Note: NCCL_HOME is the path to the RCCL installation
# Yes, they havent bothered to change the environment variable name from Nvidia's code
make \
    MPI=1 \
    MPI_HOME=$MPI_HOME \
    HIP_HOME=$HIP_HOME \
    NCCL_HOME=$RCCL_HOME

# Return to original directory
cd - > /dev/null

set +uo pipefail
