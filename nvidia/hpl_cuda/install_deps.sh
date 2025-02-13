#!/bin/bash

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

export PATH=/usr/local/cuda/bin:$PATH

# Check if CUDA driver is installed
if ! nvidia-smi; then
    echo "CUDA driver not found. Installing..."
    # Get Ubuntu version
    UBUNTU_VERSION=$(lsb_release -rs | sed 's/\.//')

    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt-get update

    apt-get install -y cuda-toolkit-12-6 nvidia-open cuda-drivers

    # Verify installation
    nvidia-smi || { echo "CUDA driver installation verification failed"; exit 1; }
fi

# Check if system has an nvswitch fabric manager, else install it
if ! dpkg -s nvidia-fabricmanager &> /dev/null; then
    echo "NVIDIA Fabric Manager not found. Installing..."
    apt-get install -y nvidia-fabricmanager-565

    # Start the fabric manager and enable it to start on boot
    systemctl start nvidia-fabricmanager
    systemctl enable nvidia-fabricmanager
fi

# Check if Docker is installed, update it, else install it
if command -v docker &> /dev/null; then
    echo "Docker is installed. Updating..."
    apt-get update
    apt-get upgrade -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker not found. Installing..."

    # Clear out any old docker packages
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove -y $pkg; done
    
    # Update and add keys
    apt-get update
    apt-get install -y ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # Install packages
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Test docker installation
    docker run hello-world || { echo "Docker installation test failed"; exit 1; }
fi

# Check if NVIDIA Container Toolkit is installed, else install it
if ! dpkg -s nvidia-container-toolkit &> /dev/null; then
    echo "NVIDIA Container Toolkit not found. Installing..."

    # Add keys and repository
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    # Update apt and install toolkit
    apt-get update
    apt-get install -y nvidia-container-toolkit

    # Configure runtime and restart docker
    nvidia-ctk runtime configure --runtime=docker
    systemctl restart docker
else
    echo "NVIDIA Container Toolkit is installed."
fi

echo "Installation complete. Would you like to reboot now? (y/n)"
read -r REBOOT
if [ "$REBOOT" = "y" ]; then
    reboot
fi
