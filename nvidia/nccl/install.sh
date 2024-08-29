#!/bin/bash

set -uo pipefail

# Set default MPI_HOME
MPI_HOME=${MPI_HOME:-/usr/lib/x86_64-linux-gnu/mpich}

# Clone and build tests
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests

make MPI=1 MPI_HOME=$MPI_HOME

# Return to original directory
cd - > /dev/null

set +uo pipefail
