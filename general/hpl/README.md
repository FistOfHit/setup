# HPL - High Performance Linpack

Installation and test benchmarking scripts for the open source HPL benchmarking suite, widely used for [top500](https://top500.org/) supercomputer benchmarking

## Includes

- `install.sh` - Installing the HPL suite, as well as OpenMPI and OpenBLAS (might want to modify on DC or other already-running systems)
- `run_test_benchmark.sh` - Run the HPL test benchmark

## Notes

- If you are not running as root: `bash install.sh` from your home directory, please do not attempt to run the install script with sudo as HPL assumes building in your home directory, which will be mapped to /root if you run with sudo
- You might wish to update the `install.sh` file with latest versions of OpenMPI, OpenBLAS and HPL, though its likely the last will be the same and OpenBLAS is cloned from the development branch, so only OpenMPI will likely need to be updated
- For testing the benchmark, use the `test.dat` file for an instant result, and play around with the parameters here to get a feel for which parameters affect runtime and utilisation in which ways. The [tuning guide](https://netlib.org/benchmark/hpl/tuning.html#tips), and calculators ([1](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/), [2](https://hpl-calculator.sourceforge.net)) may be of use
- When attempting to run the benchmark, you may see errors such as `mpirun: symbol lookup error: mpirun: undefined symbol: opal_libevent2022_event_base_loop`, these usually mean that mpirun cannot be found. This can be fixed by updating the environment variables `export PATH=<path_to_mpi>bin:$PATH` and `export LD_LIBRARY_PATH=<path_to_mpi>/lib:$LD_LIBRARY_PATH` (mpi path is usually /opt/hpcx/ompi/ in Nvidia HPC containers or properly install DGX OSs).
- in the case of errors such as `./xhpl: error while loading shared libraries: libopen-pal.so.40: cannot open shared object file: No such file or directory` it appears to work when you simply go to the openmpi/lib directory and copy the `libopen-pal.so.80` file into a `libopen-pal.so.40` file. This error is due to a missing version (.40) of the library, however it seems the .80 version is sufficient and so simply making a copy or a link to the .80 version seems to work.
- If you encounter errors such as the one below, there is likely an issue with the hostfile, or MPI needs an explicit network interface passed to it. Check the hostfile to ensure the localhost is correctly specified by checking the output `cat /etc/hosts` and seeing how the machine identifies itself (`localhost` is almost always correct). Additionally, check the output of `ifconfig` to see which network interface corresponds to the network that the other machines are on, for the Dell machines used in testing, this was `bond0.201` and pass this in the command with the arg `--mca btl_tcp_if_include <interface_name>`, but make this the first arg you pass as mpirun appears to get confused, thinking the interface name is the executable.
```
mpirun -np 208 --bind-to core --hostfile /home/dell/hostfile.txt ./xhpl 
[dell][[35271,1],128][btl_tcp_endpoint.c:667:mca_btl_tcp_endpoint_recv_connect_ack] received unexpected process identifier: got [[35271,1],104] expected [[35271,1],0]
[dell:00000] *** An error occurred in Socket closed
[dell:00000] *** reported by process [2311520257,128]
[dell:00000] *** on a NULL communicator
[dell:00000] *** Unknown error
[dell:00000] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[dell:00000] ***    and MPI will try to terminate your MPI job as well)
[dell][[35271,1],112][btl_tcp_endpoint.c:667:mca_btl_tcp_endpoint_recv_connect_ack] received unexpected process identifier: got [[35271,1],195] expected [[35271,1],96]
--------------------------------------------------------------------------
```


## Following these sources

- [M. Gaillard's tutorial](https://www.mgaillard.fr/2022/08/27/benchmark-with-hpl.html)
- [HPL.dat file tuning guide](https://netlib.org/benchmark/hpl/tuning.html)
- [HPL calculator 1](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/)
- [HPL calculator 2 (has some other good resources too for running on Infiniband or large clusters)](https://hpl-calculator.sourceforge.net)
- [OpenBLAS](https://github.com/OpenMathLib/OpenBLAS)
- [OpenMPI](https://www.open-mpi.org/)
