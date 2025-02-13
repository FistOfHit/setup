#!/bin/bash

set -uo pipefail

# Update
sudo apt update

# Check if lspci is installed else install it
if ! command -v lspci &> /dev/null; then
    sudo apt install -y pciutils
fi

# Check if dmidecode is installed else install it
if ! command -v dmidecode &> /dev/null; then
    sudo apt install -y dmidecode
fi

# Check if lsblk is installed else install it
if ! command -v lsblk &> /dev/null; then
    sudo apt-get install util-linux
fi

# Check if ipmitool is installed else install it
if ! command -v ipmitool &> /dev/null; then
    sudo apt install -y ipmitool
fi

echo "Tools installed, ready to take inventory."

set +uo pipefail
