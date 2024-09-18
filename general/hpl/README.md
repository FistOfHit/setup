# HPL - High Performance Linpack

Installation and test benchmarking scripts for the open source HPL benchmarking suite, widely used for [top500](https://top500.org/) supercomputer benchmarking

## Includes

- `install.sh` - Installing the HPL suite, as well as OpenMPI and OpenBLAS (might want to modify on DC or other already-running systems)
- `run_test_benchmark.sh` - Run the HPL test benchmark

## Notes

- You might wish to update the `install.sh` file with latest versions of OpenMPI, OpenBLAS and HPL, though its likely the last will be the same and OpenBLAS is cloned from the development branch, so only OpenMPI will likely need to be updated
- For testing the benchmark, use the `test.dat` file for an instant result, and play around with the parameters here to get a feel for which parameters affect runtime and utilisation in which ways. The [tuning guide](https://netlib.org/benchmark/hpl/tuning.html#tips), and calculators ([1](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/), [2](https://hpl-calculator.sourceforge.net)) may be of use
- The install script does not work if you are not logged in as root user, since the install paths are required to be in /root. If you cant do this, run the lines manually outside of a shell run via sudo

## Following these sources

- [M. Gaillard's tutorial](https://www.mgaillard.fr/2022/08/27/benchmark-with-hpl.html)
- [HPL.dat file tuning guide](https://netlib.org/benchmark/hpl/tuning.html)
- [HPL calculator 1](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/)
- [HPL calculator 2 (has some other good resources too for running on Infiniband or large clusters)](https://hpl-calculator.sourceforge.net)
- [OpenBLAS](https://github.com/OpenMathLib/OpenBLAS)
- [OpenMPI](https://www.open-mpi.org/)
