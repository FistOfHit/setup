#!/bin/bash

set -uo pipefail

apt-get update

# Install NCCL
apt-get install libnccl2=2.23.4-1+cuda12.6 libnccl-dev=2.23.4-1+cuda12.6 # Check if this is the correct version for your CUDA install

# Install NVIDIA Fabric Manager
apt-get install -y nvidia-fabricmanager-565 # Check if this is the correct version for your CUDA install

# Start the fabric manager and enable it to start on boot
systemctl start nvidia-fabricmanager
systemctl enable nvidia-fabricmanager

echo "Installation complete. Would you like to reboot now? (y/n)"
read -r REBOOT
if [ "$REBOOT" = "y" ]; then
    reboot
fi

set +uo pipefail
