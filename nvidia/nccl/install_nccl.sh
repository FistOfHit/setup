#!/bin/bash

set -euo pipefail

git clone https://github.com/NVIDIA/nccl.git

# Build and install
cd nccl

make -j src.build
sudo apt install build-essential devscripts debhelper fakeroot
make pkg.debian.build

# Return to original directory
cd - > /dev/null
