# GPUDirect Storage
Installation and benchmarking scripts for Nvidia device/host bandwidth

Includes:
- `install.sh` - Installing nvbandwidth 
- `device_to_device.sh` - device -> device bandwidth across the entire system
- `host_to_device.sh` - device -> host bandwidth for all devices across the entire system individually
- `all_to_host.sh` - all devices -> host and host -> all devices bandwidth simultaneously for all devices across the entire system at once
- `all_to_one.sh` - all devices -> one device and one device -> all devices bandwidth simultaneously for all devices across the entire system at once
- `latency.sh` - host -> device and device -> device latency for all devices across the entire system individually

Note:
On installing nvbandwidth, there may be Cmake issues with the version being too old. Purge, and use the link below to install a later version (post 3.20). Then retry.

Following guides from:
- [Nvbandwidth repo](https://github.com/NVIDIA/nvbandwidth/tree/main)
- [Cmake install issues](https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu)
