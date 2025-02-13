#!/bin/bash

# DO NOT RUN AS ROOT IF YOU ARE NOT ROOT
# Building and installing from source, not using a package manager

# Install pre-requisites
sudo apt install -y build-essential hwloc libhwloc-dev libevent-dev gfortran

# Set install paths for libs and hpl
export MPI_HOME=$HOME/opt/OpenMPI
export PATH=$PATH:$MPI_HOME/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$MPI_HOME/lib

# Install OpenMPI
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.gz
tar xzf openmpi-5.0.5.tar.gz
cd openmpi-5.0.5
CFLAGS="-Ofast -march=native" ./configure --prefix=$HOME/opt/OpenMPI
make -j 4 # Can modify this if you have the resouces for more parallelism in this step
make install
cd ..
rm openmpi-5.0.5.tar.gz

# Test installation
mpirun --version
