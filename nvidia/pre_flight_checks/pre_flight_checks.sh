#!/bin/bash

set -uo pipefail

# Pre-flight check script for a new system with GPUs

log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

check_nvidia_driver() {
    log_message "Checking NVIDIA driver and CUDA version..."
    if ! nvidia-smi &> /dev/null; then
        log_message "Error: NVIDIA driver not installed or nvidia-smi not found."
        exit 1
    fi
    nvidia-smi
    echo 
}

check_cuda_version() {
    log_message "Checking CUDA version..."
    if command -v nvcc &> /dev/null; then
        nvcc --version
    else
        log_message "Error: nvcc not found. Make sure CUDA is installed and added to PATH."
    fi
    echo 
}

check_cuda_libraries() {
    log_message "Checking CUDA installation path and libraries..."
    cuda_path=$(which nvcc)
    if [ -z "$cuda_path" ]; then
        log_message "CUDA not installed or nvcc not in PATH."
    else
        log_message "CUDA installed at: $(dirname $(dirname $cuda_path))"
        ls -l /usr/local | grep cuda

        if [ -f /usr/local/cuda/include/cudnn.h ]; then
            cudnn_version=$(grep "#define CUDNN_MAJOR" /usr/local/cuda/include/cudnn.h | awk '{print $3}')
            log_message "cuDNN version: $cudnn_version"
        else
            log_message "cuDNN not found."
        fi

        if [ -f /usr/include/nccl.h ]; then
            nccl_version=$(grep "#define NCCL_MAJOR" /usr/include/nccl.h | awk '{print $3}')
            log_message "NCCL version: $nccl_version"
        else
            log_message "NCCL not found."
        fi
    fi
    echo 
}

check_nvidia_toolkit() {
    log_message "Checking NVIDIA Container Toolkit..."
    if dpkg -s nvidia-container-toolkit &> /dev/null; then
        log_message "NVIDIA Container Toolkit is installed."
    else
        log_message "Error: NVIDIA Container Toolkit not found."
    fi
    echo 
}

check_cuda_toolkit() {
    log_message "Checking if CUDA Toolkit is available..."
    if dpkg -s cuda-toolkit-12-6 &> /dev/null; then
        log_message "CUDA Toolkit is installed."
    else
        log_message "Error: CUDA Toolkit not found."
    fi
    echo 
}

check_nvidia_fabric_manager() {
    log_message "Checking NVIDIA Fabric Manager..."
    if dpkg -s nvidia-fabricmanager &> /dev/null; then
        log_message "NVIDIA Fabric Manager is installed."
    else
        log_message "Error: NVIDIA Fabric Manager not found."
    fi
    echo 
}

check_mpi_version() {
    log_message "Checking MPI versions..."
    if command -v mpirun &> /dev/null; then
        mpirun --version | head -n 1
    else
        log_message "MPI not found."
    fi
    echo 
}

check_system_topology() {
    log_message "Checking GPU topology..."
    nvidia-smi topo -m # Show topology of GPUs
    echo 
}

check_gpu_details() {
    log_message "Checking GPU details..."
    nvidia-smi --query-gpu=name,power.limit,compute_cap,memory.total --format=csv,noheader,nounits
    echo 
}

check_additional_requirements() {
    log_message "Performing additional checks..."
    # Check if gcc is installed
    gcc --version || log_message "Warning: gcc not installed."

    # Check available disk space
    log_message "Available disk space:"
    df -h
    echo 
}

main() {
    log_message "Running pre-flight checks for GPU system..."

    check_nvidia_driver
    check_cuda_version
    check_cuda_libraries
    check_mpi_version
    check_system_topology
    check_gpu_details
    check_additional_requirements

    log_message "Pre-flight checks completed."
}

main

set +uo pipefail
