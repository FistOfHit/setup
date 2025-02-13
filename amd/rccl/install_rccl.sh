#!/bin/bash

# DO NOT RUN AS ROOT IF YOU ARE NOT ROOT
# Building and installing from source, not using a package manager

set -uo pipefail

# Check if ROCM is installed
if ! command -v rocm-smi &> /dev/null
then
    echo "ROCm is not installed. Please install ROCM and try again."
    exit 1
fi

# Clone RCCL repo
git clone https://github.com/ROCm/rccl.git
cd rccl

# Run install script
./install.sh \
    --install \
    --dependencies \
    --jobs 4 \
    --local_gpu_only \
    --prefix $HOME/opt/RCCL

echo "Installation complete. Would you like to reboot now? (y/n)"
read -r REBOOT
if [ "$REBOOT" = "y" ]; then
    reboot
fi

set +uo pipefail
