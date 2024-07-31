#!/bin/bash

set -euo pipefail

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for CUDA-enabled GPU and compatible NVIDIA driver
if ! command_exists nvidia-smi; then
    echo "Error: NVIDIA GPU driver not found. Please install a compatible NVIDIA driver."
    exit 1
fi

# Check for CUDA toolkit and nvcc
if ! command_exists nvcc; then
    echo "Error: nvcc not found in PATH. Please install CUDA toolkit and ensure nvcc is in your PATH."
    exit 1
fi

cuda_version=$(nvcc --version | grep "release" | awk '{print $5}' | cut -d',' -f1)
echo "CUDA version: $cuda_version"

git clone https://github.com/NVIDIA/nvbandwidth.git
cd nvbandwidth

# Use their in-built dependency installation and building script
sudo ./debian_install.sh

cd - > /dev/null
