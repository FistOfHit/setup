# GPUDirect Storage
Installation and benchmarking scripts for Nvidia device/host bandwidth

Includes:
- `install.sh` - Installing nvbandwidth
- `benchmark.sh` - Run all benchmarks including:
    - `device to device` - device -> device bandwidth across the entire system
    - `host to device` - device -> host and host -> device bandwidth for all devices across the entire system individually
    - `all to host` - all devices -> host and host -> all devices bandwidth simultaneously for all devices across the entire system at once
    - `all to one` - all devices -> one device and one device -> all devices bandwidth simultaneously for all devices across the entire system at once
    - `latency` - host -> device and device -> device latency for all devices across the entire system individually

Note:
On installing nvbandwidth, there may be Cmake issues with the version being too old. Purge, and use the link below to install a later version (post 3.20). Then retry.

Following these sources:
- [Nvbandwidth repo](https://github.com/NVIDIA/nvbandwidth/tree/main)
- [Cmake install issues](https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu)
- [Nvidia specs](https://www.nvidia.com/en-gb/data-center/)