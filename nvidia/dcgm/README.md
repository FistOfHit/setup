# NVidia DGCM

Installation and example commands for DGCM

## Notes
- NSCQ (Nvidia NVSwitch configuration and Query) is required for DGCM to work - it cannot be installed as part of the `install.sh` script as it is version specific to the CUDA version installed on the system, but it can be installed manually easily using the links below on a system with multiple GPUs connected by NVSwitches
- Nvidia fabric manager is also installed as part of the `install.sh` script

## Includes

- `install.sh` - Installing GPUDirect storage on an ubunutu with a generic kernel
- `example_commands.sh` - Example DGCM commands to use

## Following guides from

- [DGCM repo](https://github.com/NVIDIA/DCGM)
- [DGCM documentation](https://docs.nvidia.com/datacenter/dcgm/latest/contents.html)
- [NSCQ repo](https://github.com/NVIDIA/apt-packaging-libnvidia-nscq)
