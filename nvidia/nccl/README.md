# NCCL

Installation and benchmarking scripts for NCCL

## Includes

- `install.sh` - Installing the NCCL test suite
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
    - hypercube

## Notes

- To install MPI, use the `install_mpi.sh` script in the mpi dir, and it will install and test mpich
- To install NCCL (if not already present on the system) use the `install_nccl.sh` scipt in this dir, and it will install nccl

## Following these sources

- [NCCL test repo](https://github.com/NVIDIA/nccl-tests/tree/master?tab=readme-ov-file)
- [NCCL repo](https://github.com/nvidia/nccl)
- [NCCL home dir example](https://github.com/NVIDIA/nccl-tests/issues/81)
