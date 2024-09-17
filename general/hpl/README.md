# HPL - High Performance Linpack

Installation and benchmarking scripts for the open source HPL benchmarking suite, widely used for [top500](https://top500.org/) supercomputer benchmarking

## Includes

- `install.sh` - Installing the HPL suite
- `benchmark.sh` - Run the HPL benchmark

## Notes

- You might wish to update the `install.sh` file with latest versions of OpenMPI, OpenBLAS and HPL, though its likely the last will be the same and OpenBLAS is cloned from the development branch, so only OpenMPI will likely need to be updated
- For testing the benchmark, use the trivial case .dat file, for an instant result, and play around with the parameters here to get a feel for which parameters affect runtime and utilisation in which ways. The [tuning guide](https://netlib.org/benchmark/hpl/tuning.html#tips) may be of use
- The 

## Following these sources

- [M. Gaillard's tutorial](https://www.mgaillard.fr/2022/08/27/benchmark-with-hpl.html)
- [HPL.dat file tuning guide](https://netlib.org/benchmark/hpl/tuning.html)
- [OpenBLAS](https://github.com/OpenMathLib/OpenBLAS)
- [OpenMPI](https://www.open-mpi.org/)
