# GPU-System bandwidth

Installation and benchmarking scripts for Nvidia device/host bandwidth

## Includes

- `install.sh` - Installing nvbandwidth
- `benchmark.sh` - Run all benchmarks including:
    - `device to device` - device -> device bandwidth across the entire system
    - `host to device` - device -> host and host -> device bandwidth for all devices across the entire system individually
    - `all to host` - all devices -> host and host -> all devices bandwidth simultaneously for all devices across the entire system at once
    - `all to one` - all devices -> one device and one device -> all devices bandwidth simultaneously for all devices across the entire system at once
    - `latency` - host -> device and device -> device latency for all devices across the entire system individually

## Notes

- On installing nvbandwidth, there may be Cmake issues with the version being too old. Purge, and use the link below to install a later version (post 3.20). Then retry.
- When installing a newer cmake from source, you may have to install openSSL, this error should be seen in the `./configure` step
- If the CMakeLists.txt file needs to be modified to manually set the CUDA_ARCHITECTURE variable, this can be found by multiplying the output of `nvidia-smi --query-gpu=compute_cap --format=csv,noheader` by 10
- During the install step, particularly when the nvbandiwdth package is being installed, there may be an error `No CMAKE_CUDA_COMPILER could be found.` etc. This can be fiexd by setting the path variables `export PATH=/usr/local/cuda/bin:$PATH && export LD_LIBRARY_PATH=/usr/loc
al/cuda/lib64:$LD_LIBRARY_PATH` and then updating `debian_install.sh` in the nvbandiwdth repo dir to use the line `cmake -DCMAKE_CUDA_COMPILER=<path_to_nvcc> ..` instead of `cmake ..`

## Following these sources

- [Nvbandwidth repo](https://github.com/NVIDIA/nvbandwidth/tree/main)
- [Cmake install issues](https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu)
- [Nvidia specs](https://www.nvidia.com/en-gb/data-center/)
