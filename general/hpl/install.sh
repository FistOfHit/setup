#!bin/bash

set -uo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Install pre-requisites
sudo apt install build-essential hwloc libhwloc-dev libevent-dev gfortran

# Set install paths for libs and hpl
CURRENT_DIR=$(pwd)
export MPI_HOME=$CURRENT_DIR/opt/OpenMPI
export PATH=$PATH:$MPI_HOME/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$MPI_HOME/lib

# Install OpenBLAS
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make -j 4 # Can modify this if you have the resouces for more parallelism in this step
make PREFIX=$CURRENT_DIR/opt/OpenBLAS install
cd ..

# Install OpenMPI
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.gz
tar xzf openmpi-5.0.5.tar.gz
cd openmpi-5.0.5
CFLAGS="-Ofast -march=native" ./configure --prefix=$CURRENT_DIR/opt/OpenMPI
make -j 4 # Can modify this if you have the resouces for more parallelism in this step
make install
cd ..
rm openmpi-5.0.5.tar.gz

# Download HPL
wget https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
tar xzf hpl-2.3.tar.gz
mv hpl-2.3 ~/hpl
rm hpl-2.3.tar.gz

# Configure HPL
cd hpl/setup
sh make_generic
cp Make.UNKNOWN ../Make.linux
cd ..

# Modify contents of Make.linux - Only for machines where we installed 
# OpenMPI and OpenBLAS ourselves, not datacenter machines with OS's
# That have proprietary versions pre-installed
sed -i 's/^ARCH\s*=.*/ARCH          = linux/' Make.linux
sed -i 's|^MPdir\s*=.*|MPdir        = $(HOME)/opt/OpenMPI|' Make.linux
sed -i 's|^MPinc\s*=.*|MPinc        = -I$(MPdir)/include|' Make.linux
sed -i 's|^MPlib\s*=.*|MPlib        = $(MPdir)/lib/libmpi.so|' Make.linux
sed -i 's|^LAdir\s*=.*|LAdir        = $(HOME)/opt/OpenBLAS|' Make.linux
sed -i 's/^LAinc\s*=.*/LAinc        =/' Make.linux
sed -i 's|^LAlib\s*=.*|LAlib        = $(LAdir)/lib/libopenblas.a|' Make.linux

# Finally, make the benchmark
make arch=linux

echo "Benchmarks ready, please check or configure HPL.dat in ./bin/linux to run"

set +uo pipefail
