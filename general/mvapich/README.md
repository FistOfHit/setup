# MVAPICH

Installation and testing for MVAPICH

## Includes

- `install.sh` - Installing MVAPICH
- `hello.c` - test file for mpiexec

## Notes

- MVAPICH should be able to replace OpenMPI as the MPI library on the system, and many large HPC systems use MVAPICH as the default MPI library from hyperscalers like AWS, GCP, and Azure, but we ourselvers have not tested this.
- Spack is currently the easiest way to install MVAPICH, but it may require a newer version of GCC/Gfortran than what is available on the system. to install these, run 'sudo apt-get update && sudo apt-get install gcc gfortran'
- Once loaded by spack, the module replaces the system mpicc/mpifort/mpiexec with the mvapich versions, so the system versions are not used. Open-MPI might be the default version on the system, so to revert to this, simply run 'spack unload mvapich'

## Following these sources

- [MVAPICH offical downloads](https://mvapich.cse.ohio-state.edu/downloads/)
