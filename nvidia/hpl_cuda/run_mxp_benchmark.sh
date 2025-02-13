#!/bin/bash

# INTENDED TO BE RUN FROM WITHIN THE CONTAINER

set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check for required commands
command -v nvidia-smi >/dev/null 2>&1 || { echo >&2 "nvidia-smi is required but it's not installed. Aborting."; exit 1; }
command -v docker --version >/dev/null 2>&1 || { echo >&2 "docker is required but it's not installed. Aborting."; exit 1; }
command -v mpirun --version >/dev/null 2>&1 || { echo >&2 "mpirun is required but it's not installed. Aborting."; exit 1; }

# Parameters
GPU_COUNT=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | wc -l)
TIMEOUT_DURATION="1h"
DOCKER_IMAGE="hpc_benchmarks"

# Problem sizes - TODO: modify these manually before running
# Parameters to be manually modified before running or provided as inputs during runtime
# N: Problem size
# NB: Block size
# NPROW: Number of process rows (try to make it close to the square root of the number of GPUs)
# NPCOL: Number of process columns (try to make it close to the square root of the number of GPUs)
# GPU_AFFINITY: GPU affinity string (e.g., 0:1:2:3 for 4 GPUs)
# NPORDER: Process ordering (row or column)

N=${1:-92800}  # Default value, can be overridden by command-line argument
NB=${2:-1024}  # Default value, can be overridden by command-line argument
NPROW=${3:-1}  # Default value, can be overridden by command-line argument
NPCOL=${4:-1}  # Default value, can be overridden by command-line argument
GPU_AFFINITY=${5:-"0:1:2:3..."}  # Default value, can be overridden by command-line argument
NPORDER=${6:-"row"}  # Default value, can be overridden by command-line argument

# Prompt user for confirmation or modification
read -p "Problem size (N) [${N}]: " input_N
N=${input_N:-$N}

read -p "Block size (NB) [${NB}]: " input_NB
NB=${input_NB:-$NB}

read -p "Number of process rows (NPROW) [${NPROW}]: " input_NPROW
NPROW=${input_NPROW:-$NPROW}

read -p "Number of process columns (NPCOL) [${NPCOL}]: " input_NPCOL
NPCOL=${input_NPCOL:-$NPCOL}

read -p "GPU affinity (GPU_AFFINITY) [${GPU_AFFINITY}]: " input_GPU_AFFINITY
GPU_AFFINITY=${input_GPU_AFFINITY:-$GPU_AFFINITY}

read -p "Process ordering (NPORDER) [${NPORDER}]: " input_NPORDER
NPORDER=${input_NPORDER:-$NPORDER}

# Timed for 1 hour cycles in datacenter burn tests
LOG_FILE="hpl_benchmark_$(date +%Y%m%d_%H%M%S).log"
timeout ${TIMEOUT_DURATION} docker run \
  --rm \
  --gpus all \
  --shm-size=1g \
  --ipc=host \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  ${DOCKER_IMAGE} \
  mpirun --bind-to none -np ${GPU_COUNT} ./hpl-mxp.sh \
    -n ${N} \
    -nb ${NB} \
    -nprow ${NPROW} \
    -npcol ${NPCOL} \
    -nporder ${NPORDER} \
    -gpu-affinity ${GPU_AFFINITY} \
  > >(tee -a "${LOG_FILE}") 2>&1

echo "Benchmark output saved to ${LOG_FILE}"

if [ $? -eq 124 ]; then
  echo "Benchmark terminated after reaching ${TIMEOUT_DURATION} time limit."
fi

set +euo pipefail
