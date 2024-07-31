#!/bin/bash

set -euo pipefail

# Install GDS on ubuntu

# Search and replace all TODOs with appropriate values
# Check if TODOs haven't been replaced and refuse to run otherwise
if grep -q "TODO" "$0"; then
    echo "Please replace all TODOs in this script before running it."
    exit 1
fi

CUDA_VERSION=TODO
CUDA_PATH="/usr/local/cuda-${CUDA_VERSION}"

# Pre-installation checks
iommu_check=$(dmesg | grep -i iommu)

# IOMMU check
if [ -z "$iommu_check" ]; then
    echo "IOMMU appears to be disabled. Proceeding with installation."
else
    echo "IOMMU appears to be enabled. Installation cannot proceed."
    echo "IOMMU messages found:"
    echo "$iommu_check"
    echo "Please disable IOMMU using `disable_iommu.sh` and try again."
    exit 1
fi

# Generic kernel install
NVIDIA_DRV_VERSION=$(cat /proc/driver/nvidia/version | grep Module | awk '{print $8}' | cut -d '.' -f 1)

echo "Installing GDS package"
sudo apt install nvidia-gds-TODO nvidia-dkms-${NVIDIA_DRV_VERSION}-server

# Enable relaxed NVMe ordering
echo "Enabling relaxed NVMe ordering"
sudo /bin/nvidia-relaxed-ordering-nvme.sh enable

# Verify installation
echo "Verifying installation"
${CUDA_PATH}/gds/tools/gdscheck.py -p
