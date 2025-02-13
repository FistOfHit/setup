#!/bin/bash

set -uo pipefail

# Install spack
git clone https://github.com/spack/spack.git
source spack/share/spack/setup-env.sh

# Install MVAPICH and load
spack install mvapich@3.0
spack load mvapich

# Test MVAPICH
mpicc -o hello hello.c && mpiexec -np 4 ./hello

set +uo pipefail
