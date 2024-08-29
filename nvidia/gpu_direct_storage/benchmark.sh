#!/bin/bash

set -uo pipefail

# Search and replace all TODOs with appropriate values
# Check if TODOs haven't been replaced and refuse to run otherwise
if grep -q "TODO" "$0"; then
    echo "Please replace all TODOs in this script before running it."
    exit 1
fi

CUDA_VERSION=TODO
CUDA_PATH="/usr/local/cuda-${CUDA_VERSION}"
GDSIO_PATH="${CUDA_PATH}/tools/gdsio"
FIO_FILES_PATH=TODO

# Check for pre-requisites
echo "Checking for pre-requisites..."
if [ -f "../../pre-requisites_checks.sh" ]; then
    source ../../pre-requisites_checks.sh
else
    echo "Error: pre-requisites_checks.sh not found."
    exit 1
fi

# Present all Nvidia PCI devices
echo "Nvidia PCI devices:"
lspci | grep -i nvidia

# Determine GPU affinity to switches/buses
echo "PCI device tree:"
lspci -tv

# Present nvidia device topology
echo "Nvidia device topology:"
nvidia-smi topo -mp

# Verify GDSIO installation
"${GDSIO_PATH}" --help

# Run benchmarks
echo "Running benchmarks..."
run_benchmark() {
    echo "$1"
    "${GDSIO_PATH}" -f "${FIO_FILES_PATH}/$2" -d 0 -w 4 -s 10G -i 1M -I 0 -x "$3"
}

run_benchmark "Storage -> GPU" "fio-seq-writes-1" 0
run_benchmark "Storage -> GPU batch" "fio-seq-read-1" 6
run_benchmark "Storage -> GPU async" "fio-seq-read-1" 5
run_benchmark "Storage -> CPU" "fio-seq-writes-1" 1
run_benchmark "Storage -> CPU -> GPU" "fio-seq-writes-1" 2

# Get GDS stats
gdsio -D TODO -d 2 -w 8 -s 1G -i 1M -x 0 -I 0 -T 300 &
GDS_STATS_PID=$!
gds_stats -p $GDS_STATS_PID -l 3

set +uo pipefail
