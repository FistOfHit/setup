# HPL CUDA - High Performance Linpack for NVIDIA GPUs

Installation and test benchmarking scripts for Nvidia's HPL benchmarking suite for GPUs, via their HPC image.

## Includes

- `install_deps.sh` - Installing the image and preparing the environment
- `build_image.sh` - Build the docker image
- `run_benchmark.sh` - Run the container and the HPL test benchmark

## Notes

- To install, run `sudo ./install_deps.sh`, this needs to be run as root. Additionally, you might need to modify the path to cuda in the script to make sure it can find nvcc when determining whether or not to install it for you. 
- The `install_deps.sh` script will also attempt to reboot the machine at the end of the installation process with permission, this is necessary for the installation of the NVIDIA Container Toolkit.
- The `build_image.sh` script will build the docker image, this needs to be run before running the `run_benchmark.sh` script.
- The `run_benchmark.sh` script will run the container and the HPL test benchmark, this needs to be run after building the image. There will be no interactive output from the container, but the results will be saved to the current directory.

## Following these sources

- [Nvidia's NGC image](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/hpc-benchmarks)
- [Official documentation](https://docs.nvidia.com/nvidia-hpc-benchmarks/HPL_benchmark.html#running-the-nvidia-hpl-benchmarks-on-x86-64-with-nvidia-gpus-and-nvidia-grace-hopper-systems)
