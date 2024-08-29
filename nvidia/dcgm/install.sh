#!/bin/bash

set -uo pipefail

CUDA_VERSION=

# Delete old keys
sudo apt-key del 7fa2af80

# Add keys
DIST=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
wget https://developer.download.nvidia.com/compute/cuda/repos/$DIST/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update

# Install DGCM
sudo apt-get install -y datacenter-gpu-manager

# Install NSCQ
sudo apt-get install -y libnvidia-nscq-$CUDA_VERSION

# Enable and verify
sudo systemctl --now enable nvidia-dcgm
dcgmi discovery -l

set +uo pipefail
