# NCCL

Installation and benchmarking scripts for RCCL

## Includes

- `install.sh` - Installing the RCCL test suite
- `benchmark.sh` - Run all benchmarks including:
    - all_reduce
    - all_gather
    - broadcast
    - reduce_scatter
    - reduce
    - alltoall
    - scatter
    - gather
    - sendrecv
- `semianalysis/benchmark.sh` - Run the semianalysis docker container
## Notes

- To install MPI, use the `install_mpi.sh` script in the mpi dir, and it will install and test mpich
- To install RCCL (if not already present on the system) use the `install_nccl.sh` scipt in this dir, and it will install nccl, though please check to ensure the version is correct with the CUDA version installed on the system.
- The `single_node_benchmark.sh` script is set up for single node runs, for multi-node runs, please use the `multi_node_benchmark.sh` script. Make sure to modify both with the parameters desired for this run.
- For multi-node runs, ensure mpirun is in the path (and the lib is on the ld path, can use the following command: `export PATH=$PATH:$MPI_HOME/bin && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPI_HOME/lib` where `$MPI_HOME` is the path to the mpi installation). Also ensure the hostfile is correctly specified.
- The default parameters for the benchmarks are set to run for 100 iterations, with a minimum of 2MB and a maximum of 16GB, with a step factor of 2 (doubling size of collective op each time).
- These benchmarks are setup to test the maximum bandwidth and correctness of the Infinity Fabric system between GPUs, and so are not the best benchmarks for testing the latency. To get a better indication of latency, please modify the benchmarks to use much smaller sizes (8 to 64 bytes etc.)
- The semianalysis benchmark is setup to run the RCCL tests fully inside another container, requiring only that ROCM is installed on the host.

## Following these sources

- [RCCL test repo](https://github.com/ROCm/rccl-tests)
- [RCCL repo](https://github.com/ROCm/rccl)
