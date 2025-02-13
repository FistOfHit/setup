#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

# Check if CUDA driver is installed
if ! nvidia-smi; then
    echo "CUDA driver not found. Installing..."

    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb > /dev/null 2>&1
    dpkg -i cuda-keyring_1.1-1_all.deb > /dev/null 2>&1
    apt-get update

    apt-get install -y cuda-toolkit-12-8 nvidia-open
    apt-get install -y cuda-drivers

    # Verify installation
    nvidia-smi || { echo "CUDA driver installation verification failed"; exit 1; }
fi

# Check if system has an nvswitch fabric manager, else install it
if ! dpkg -s nvidia-fabricmanager &> /dev/null; then
    echo "NVIDIA Fabric Manager not found. Installing..."
    apt-get install -y nvidia-fabricmanager

    # Start the fabric manager and enable it to start on boot
    systemctl start nvidia-fabricmanager > /dev/null 2>&1
    systemctl enable nvidia-fabricmanager > /dev/null 2>&1
fi

# Check if NSCQ is installed
if ! command -v nvidia-nscq &> /dev/null; then
  echo "NSCQ is not installed"
  apt-get install -y libnvidia-nscq > /dev/null 2>&1
fi

# Pre-update
sudo apt-get update

# Add keys
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb > /dev/null 2>&1
sudo dpkg -i cuda-keyring_1.0-1_all.deb > /dev/null 2>&1
sudo add-apt-repository -y "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /dev/null 2>&1

# Post-update
sudo apt-get update

# Install DGCM
sudo apt-get install -y --install-recommends datacenter-gpu-manager

# Enable
sudo systemctl --now enable nvidia-dcgm > /dev/null 2>&1
