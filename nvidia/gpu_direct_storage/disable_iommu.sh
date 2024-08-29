#!/bin/bash

set -uo pipefail

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

# Detect CPU type
if grep -q "AMD" /proc/cpuinfo; then
    IOMMU_OPTION="amd_iommu=off"
elif grep -q "Intel" /proc/cpuinfo; then
    IOMMU_OPTION="intel_iommu=off"
else
    echo "Unable to determine CPU type. Please manually edit /etc/default/grub"
    exit 1
fi

# Backup original grub file
cp /etc/default/grub /etc/default/grub.backup

# Modify GRUB configuration
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
    # If the line exists, append our option
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$IOMMU_OPTION /" /etc/default/grub
else
    # If the line doesn't exist, add it
    echo "GRUB_CMDLINE_LINUX_DEFAULT=\"$IOMMU_OPTION\"" >> /etc/default/grub
fi

# Update GRUB
update-grub

echo "IOMMU has been disabled in GRUB configuration."
echo "Please reboot your system for changes to take effect."
echo "After reboot, you can verify the change by running: cat /proc/cmdline"

# Ask user if they want to reboot now
read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    reboot
fi

set +uo pipefail
